$config = [ordered]@{
	lang         = "";
	watch        = $true;
	watchPath    = $null;
	location     = $null;
	size         = "512, 900";
	imageHeight  = 768;
	fixed        = $false;
	foreColor    = "#aaaaaa";
	backColor    = "#000000";
	imageInfo    = $true;
	topmost      = "Update"; # Update, Always, None
	scaleSens    = 1.2;
	maxScale     = 32.0;
	nearestScale = 4.0;
	keySens      = 128;
	maxFileEnum  = 100000;
	movePathA    = "a";
	movePathS    = "s";
	movePathD    = "d";
};

$configPath = [System.IO.Path]::ChangeExtension($PSCommandPath, ".json");
function SaveConfig() {
	$json = ConvertTo-Json $config;
	Set-Content -Path $configPath -Value $json -Encoding UTF8;
}

if ([System.IO.File]::Exists($configPath)) {
	$json = Get-Content -Path $configPath -Encoding UTF8 -Raw | ConvertFrom-Json;
	foreach ($prop in $json.PsObject.Properties) { $config[$prop.Name] = $prop.Value; }
	SaveConfig;
}

function GetConfig() { return $config; }

$localizedDics = @{
	"ja-JP" = @{
		"SELECT_FOLDER" = "Stable Diffusion web UI の画像出力フォルダを選択してください。" +
		"通常は web UI インストール先の「stable-diffusion-webui/outputs/」を選択します。";
		"NEXT"          = "次へ (F)";
		"PREV"          = "戻る (R)";
		"KEY_DIST"      = "ASD キーで画像振り分け";
		"SHOW_INFO"     = "情報表示";
		"FIXED_WIN"     = "ウィンドウの固定";
		"TOP"           = "最前面に表示...";
		"TOP_UPDATE"    = "更新で最前面";
		"TOP_ALWAYS"    = "常に最前面";
		"TOP_NONE"      = "最前面にしない";
		"AUTO"          = "自動読み込み";
		"AUTO_FOLDER"   = "自動読み込みフォルダ選択...";
		"EXIT"          = "終了";
	};
	"en-US" = @{
		"SELECT_FOLDER" = "Select an image output folder for Stable Diffusion web UI. " +
		"Normally, select ""stable-diffusion-webui/outputs/"" in the web UI installation directory.";
		"NEXT"          = "Next (F)";
		"PREV"          = "Previous (R)";
		"KEY_DIST"      = "ASD key to move image";
		"SHOW_INFO"     = "Information display";
		"FIXED_WIN"     = "Fixed window";
		"TOP"           = "Topmost ...";
		"TOP_UPDATE"    = "Update";
		"TOP_ALWAYS"    = "Always";
		"TOP_NONE"      = "None";
		"AUTO"          = "Auto-load";
		"AUTO_FOLDER"   = "Auto-load folder selection ...";
		"EXIT"          = "Exit";
	};
};

if ([string]::IsNullOrEmpty($config.lang)) {
	$config.lang = (Get-Culture).Name; 
}
if (!$localizedDics.ContainsKey($config.lang)) { $config.lang = "en-US"; }
SaveConfig;
$localizedDic = $localizedDics[$config.lang];
function GetText($textKey) {
	if (!$localizedDic.ContainsKey($textKey)) { Write-Error "Text not found: $textKey" }
	return $localizedDic[$textKey];
}

Add-Type -AssemblyName System.Drawing;
function TransformPoints ($mtx, $x0, $y0, $x1, $y1) {
	[System.Drawing.PointF[]] $points = @(
		([System.Drawing.PointF]::new($x0, $y0)), ([System.Drawing.PointF]::new($x1, $y1)));
	$mtx.TransformPoints($points);
	return $points;
}

Add-Type -AssemblyName System.Windows.Forms;
class GenImageViewer {
	$form;
	$image;
	$imagePath;
	$imageCanvasRate = 1.0;
	$canvas;
	$canvasMtx;
	$canvasMDragX = -1;
	$canvasMDragY = -1;
	$textArea;
	$keyDownTimer;
	$keyDownDistImage = $false;
	$watcher;

	[void] InitializeForm() {
		$cfg = GetConfig;
		$frm = New-Object System.Windows.Forms.Form;
		$this.form = $frm;
		if ($cfg.fixed) { $frm.FormBorderStyle = "None"; }
		else { $frm.FormBorderStyle = "Sizable"; }
		$frm.ClientSize = $cfg.size;
		$frm.BackColor = $cfg.backColor;
		$frm.BackgroundImageLayout = "Zoom";
		if ($null -ne $cfg.location) {
			$frm.StartPosition = "Manual";
			$frm.Location = $cfg.location;
		}
		$frm.Tag = $this;
		$frm.add_ResizeEnd({
				$cfg = GetConfig;
				$cfg.location = "$($this.Location.X), $($this.Location.Y)";
				$cfg.size = "$($this.ClientSize.Width), $($this.ClientSize.Height)";
				$cfg.imageHeight = $this.Controls[0].SplitterDistance; # SplitterMovedでケアできてるはず
				SaveConfig;
				$this.Tag.canvas.Invalidate();
			});
		if ($cfg.topmost -eq "Always") { $frm.Topmost = $true; }
		$frm.AllowDrop = $true;
		$frm.add_DragEnter({ if ($_.Data.GetDataPresent("FileDrop")) { $_.Effect = "Copy"; } });
		$frm.add_DragDrop({
				foreach ($path in $_.Data.GetData("FileDrop")) {
					if ([System.IO.File]::Exists($path) -and
						([System.IO.Path]::GetExtension($path) -eq ".png")) {
						$this.Tag.SetImage($path);
						return;
					}
					elseif ([System.IO.Directory]::Exists($path)) {
						$this.Tag.FindImage($path);
						return;
					}
				}
			});
		$frm.add_KeyDown({ $this.Tag.KeyDown($_); });

		$splt = New-Object System.Windows.Forms.SplitContainer;
		$splt.Orientation = "Horizontal";
		$splt.Dock = "Fill";
		$this.form.Controls.Add($splt);
		$splt.SplitterDistance = $cfg.imageHeight;
		$splt.Tag = $this;
		$splt.add_SplitterMoved({
				$cfg = GetConfig;
				$cfg.imageHeight = $this.SplitterDistance;
				SaveConfig;
			});
		$splt.add_MouseMove({ $this.IsSplitterFixed = $false; });
		$splt.add_KeyDown({
				$this.IsSplitterFixed = $true;
				$this.Tag.KeyDown($_);
			});
		$this.keyDownTimer = New-Object System.Diagnostics.StopWatch;
		$this.keyDownTimer.Start();

		$cnvs = New-Object System.Windows.Forms.PictureBox;
		$this.canvas = $cnvs;
		$this.canvasMtx = New-Object System.Drawing.Drawing2D.Matrix;
		$cnvs.Dock = "Fill";
		$cnvs.Tag = $this;
		$cnvs.SizeMode = "Zoom";
		$cnvs.Add_MouseMove({ $this.Tag._MouseMove($_, $this); });
		$cnvs.Add_MouseWheel({ $this.Tag._MouseWheel($_, $this); });
		$cnvs.Add_Paint({ $this.Tag._RepaintCanvas($_, $this); });
		$splt.Panel1.Controls.Add($cnvs);

		$txar = New-Object System.Windows.Forms.TextBox;
		$this.textArea = $txar;
		$txar.ForeColor = $cfg.foreColor;
		$txar.BackColor = $cfg.backColor;
		$txar.Dock = "Fill";
		$txar.Multiline = $true;
		$txar.ScrollBars = "Vertical";
		$txar.ShortcutsEnabled = $true;
		$txar.Readonly = $true;
		$txar.Tag = $this;
		$txar.add_KeyDown({
				if ($_.KeyCode -eq "A" -and $_.Control) { $this.SelectAll(); }
				$this.Tag.KeyDown($_);
			});
		$splt.Panel2.Controls.Add($txar);

		$ctmn = New-Object System.Windows.Forms.ContextMenuStrip;
		$ctmn.Tag = $this;

		$mNxt = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "NEXT");
		$mNxt.Tag = $this;
		$mNxt.add_Click({ $this.Tag.SetNextImage(); });
		$ctmn.Items.Add($mNxt);

		$mPrv = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "PREV");
		$mPrv.Tag = $this;
		$mPrv.add_Click({ $this.Tag.SetPrevImage(); });
		$ctmn.Items.Add($mPrv);

		$mKfm = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "KEY_DIST");
		$mKfm.Tag = $this;
		$mKfm.add_Click({ $this.Tag.keyDownDistImage = !$this.Tag.keyDownDistImage; });
		$ctmn.Items.Add($mKfm);
		$ctmn.Items.Add("-");

		$mIif = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "SHOW_INFO");
		$splt.Panel2Collapsed = !$cfg.imageInfo;
		$mIif.Tag = $splt;
		$mIif.add_Click({
				$cfg = GetConfig;
				$cfg.imageInfo = !$cfg.imageInfo;
				SaveConfig;
				$this.Tag.Panel2Collapsed = !$cfg.imageInfo;
			});
		$ctmn.Items.Add($mIif);

		$mWfx = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "FIXED_WIN");
		$mWfx.Tag = $frm;
		$mWfx.add_Click({
				$cfg = GetConfig;
				$cfg.fixed = !$cfg.fixed;
				SaveConfig;
				$frmSize = $this.Tag.Size;
				if ($cfg.fixed) { $this.Tag.FormBorderStyle = "None"; }
				else { $this.Tag.FormBorderStyle = "Sizable"; }
				$this.Tag.Size = $frmSize;
			});
		$ctmn.Items.Add($mWfx);

		$mTp = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "TOP");
		$mTpU = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "TOP_UPDATE");
		$mTpU.Tag = $frm;
		$mTpU.add_Click({
				$cfg = GetConfig;
				$cfg.topmost = "Update";
				SaveConfig;
				$this.Tag.topmost = $false;
			});
		$mTp.DropDownItems.Add($mTpU);

		$mTpA = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "TOP_ALWAYS");
		$mTpA.Tag = $frm;
		$mTpA.add_Click({
				$cfg = GetConfig;
				$cfg.topmost = "Always";
				SaveConfig;
				$this.Tag.topmost = $true;
			});
		$mTp.DropDownItems.Add($mTpA);

		$mTpN = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "TOP_NONE");
		$mTpN.Tag = $frm;
		$mTpN.add_Click({
				$cfg = GetConfig;
				$cfg.topmost = "None";
				SaveConfig;
				$this.Tag.topmost = $false;
			});
		$mTp.DropDownItems.Add($mTpN);

		$ctmn.Items.Add($mTp);
		$ctmn.Items.Add("-");

		$mWc = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "AUTO");
		$mWc.Tag = $this;
		$mWc.add_Click({
				$cfg = GetConfig;
				$cfg.watch = !$cfg.watch;
				SaveConfig;
				$this.Tag.Watch();
			});
		$ctmn.Items.Add($mWc);

		$mWcF = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "AUTO_FOLDER");
		$mWcF.Tag = $this;
		$mWcF.add_Click({
				$this.Tag.OpenWatchFolderDialog();
			});
		$ctmn.Items.Add($mWcF);

		$ctmn.Items.Add("-");

		$mCls = New-Object System.Windows.Forms.ToolStripMenuItem (GetText "EXIT");
		$mCls.Tag = $frm;
		$mCls.add_Click({ $this.Tag.Close(); });
		$ctmn.Items.Add($mCls);	

		$ctmn.add_Opened({
				$cfg = GetConfig;
				$idx = 2;
				$this.Items[$idx].Checked = $this.Tag.keyDownDistImage;
				$idx += 2;
				$this.Items[$idx].Checked = $cfg.imageInfo;
				$idx++;
				$this.Items[$idx].Checked = $cfg.fixed;
				$idx++;
				$this.Items[$idx].DropDownItems[0].Checked = $cfg.topmost -eq "Update";
				$this.Items[$idx].DropDownItems[1].Checked = $cfg.topmost -eq "Always";
				$this.Items[$idx].DropDownItems[2].Checked = $cfg.topmost -eq "None";
				$idx += 2;
				$this.Items[$idx].Checked = $cfg.watch;
				$idx += 2;
			});

		$this.form.ContextMenuStrip = $ctmn;
	}

	[void] KeyDown($e) {
		if ($null -eq $this.image) { return; }

		$cfg = GetConfig;
		if ($e.KeyCode -eq "Up") {
			$this.canvasMtx.Translate(0, $cfg.keySens, "Append");
			$this.canvas.Invalidate();
		}
		if ($e.KeyCode -eq "Down") {
			$this.canvasMtx.Translate(0, - $cfg.keySens, "Append");
			$this.canvas.Invalidate();
		}
		if ($e.KeyCode -eq "Left") {
			$this.canvasMtx.Translate($cfg.keySens, 0, "Append");
			$this.canvas.Invalidate();
		}
		if ($e.KeyCode -eq "Right") {
			$this.canvasMtx.Translate(-$cfg.keySens, 0, "Append");
			$this.canvas.Invalidate();
		}

		if ($this.keyDownTimer.ElapsedMilliseconds -le 200) { return; } # 連打対策

		if ($e.KeyCode -eq "F") {
			$this.SetNextImage();
			$this.keyDownTimer.Restart();
		}
		elseif ($e.KeyCode -eq "R") {
			$this.SetPrevImage();
			$this.keyDownTimer.Restart();
		}
		if ($this.keyDownDistImage) {
			$cfg = GetConfig;
			if ($e.KeyCode -eq "A") { $this.DistImage($cfg.movePathA); }
			elseif ($e.KeyCode -eq "S") { $this.DistImage($cfg.movePathS); }
			elseif ($e.KeyCode -eq "D") { $this.DistImage( $cfg.movePathD); }
		}
	}

	[void] _MouseMove($e, $canvas) {
		if ($null -eq $this.image) { return; }
		if ($e.Button -ne "Left") { 
			$this.canvasMDragX = $this.canvasMDragY = -1;
			return;
		}
		if ($this.canvasMDragX -eq -1) {
			$this.canvasMDragX = $e.X;
			$this.canvasMDragY = $e.Y;
		}
		else {
			$this.canvasMtx.Translate(
				$e.X - $this.canvasMDragX, $e.Y - $this.canvasMDragY, "Append");
			$this.canvas.Invalidate();

			$this.canvasMDragX = $e.X;
			$this.canvasMDragY = $e.Y;
		}
	}

	[void] _MouseWheel($e, $canvas) {
		if ($null -eq $this.image) { return; }

		$cfg = GetConfig;
		$scale = 1.0;
		if ($e.Delta -lt 0) { $scale = 1.0 / $cfg.scaleSens; }
		elseif ($e.Delta -gt 0) { $scale = $cfg.scaleSens; }

		$nextScale = $this.canvasMtx.Elements[0] * $this.imageCanvasRate * $scale;
		if ($nextScale -gt $cfg.maxScale) { return; }

		$x = ($e.X - $this.canvasMtx.Elements[4]) / $this.canvasMtx.Elements[0];
		$y = ($e.Y - $this.canvasMtx.Elements[5]) / $this.canvasMtx.Elements[3];

		$this.canvasMtx.Translate($x, $y, "Prepend");
		$this.canvasMtx.Scale($scale, $scale, "Prepend");
		$this.canvasMtx.Translate(-$x, - $y, "Prepend");
		$this.canvas.Invalidate();
	}

	[void] _RepaintCanvas($e, $canvas) {
		if ($null -eq $this.image) { return; }
		$cfg = GetConfig;
		$iWidth = $this.image.Width;
		$iHeight = $this.image.Height;
		$cWidth = $this.canvas.Width;
		$cHeight = $this.canvas.Height;

		$xScale = [float]$cWidth / $iWidth;
		$yScale = [float]$cHeight / $iHeight;
		$icRate = $xScale;
		if ($xScale -gt $yScale) { $icRate = $yScale; }
		$this.imageCanvasRate = $icRate;

		$drWidth = $iWidth * $icRate;
		$drHeight = $iHeight * $icRate;
		$drX = ($cWidth - $drWidth) * 0.5;
		$drY = ($cHeight - $drHeight) * 0.5;

		if ($this.canvasMtx.Elements[0] -lt 1.0) {
			$this.canvasMtx.Reset();
		}
		else {
			$points = TransformPoints $this.canvasMtx $drX $drY ($drX + $drWidth) ($drY + $drHeight);
			if ($points[0].X -gt ($cWidth * 0.5)) {
				$this.canvasMtx.Translate(($cWidth * 0.5) - $points[0].X, 0.0, "Append");
			}
			elseif ($points[1].X -le ($cWidth * 0.5)) {
				$this.canvasMtx.Translate(($cWidth * 0.5) - $points[1].X, 0.0, "Append");
			}
			if ($points[0].Y -gt ($cHeight * 0.5)) {
				$this.canvasMtx.Translate(0.0, ($cHeight * 0.5) - $points[0].Y, "Append");
			}
			elseif ($points[1].Y -le ($cHeight * 0.5)) {
				$this.canvasMtx.Translate(0.0, ($cHeight * 0.5) - $points[1].Y, "Append");
			}
		}


		$scale = $icRate * $this.canvasMtx.Elements[0];
		$fileName = [System.IO.Path]::GetFileName($this.imagePath);
		$this.form.Text = "[ $iWidth x $iHeight ] x {0:f2} $($fileName)" -f $scale;

		$gfx = $e.Graphics;
		$gfx.CompositingMode = "SourceCopy";
		if ($scale -gt $cfg.nearestScale) { $gfx.InterpolationMode = "NearestNeighbor"; }
		else { $gfx.InterpolationMode = "Bicubic"; } # HighQualityBicubic or Bicubic

		$gfx.Transform = $this.canvasMtx;
		$drawRect = New-Object System.Drawing.RectangleF($drX, $drY, $drWidth, $drHeight);
		$gfx.DrawImage($this.image, $drawRect);
	}

	[void] Watch() {
		$cfg = GetConfig;
		if ($cfg.watch) {
			if (($null -eq $cfg.watchPath) -or ![System.IO.Directory]::Exists($cfg.watchPath)) {
				$this.OpenWatchFolderDialog();
				return; # ダイアログ表示後にWatchが呼ばれる
			}
		}

		if ($cfg.watch) {
			if ($null -eq $this.watcher) {
				$this.watcher = New-Object System.IO.FileSystemWatcher;
				$this.watcher.Filter = "*.png";
				$this.watcher.IncludeSubdirectories = $true;
				$this.watcher.NotifyFilter = "FileName";
				$this.watcher.SynchronizingObject = $this.form;
				$this.watcher.add_Renamed({ $imageViewer.SetImage($_.FullPath); });
			}
			$this.watcher.Path = $cfg.watchPath;
			$this.watcher.EnableRaisingEvents = $true;
		}
		else {
			if ($null -ne $this.watcher) { $this.watcher.EnableRaisingEvents = $false; }
		}
	}

	[void] OpenWatchFolderDialog() {
		$cfg = GetConfig;

		$dialog = New-Object System.Windows.Forms.FolderBrowserDialog;
		$dialog.Description = (GetText "SELECT_FOLDER");
		if (($null -eq $cfg.watchPath) -or ![System.IO.Directory]::Exists($cfg.watchPath)) {
			$dialog.SelectedPath = "C:\";
		}
		else {
			$dialog.SelectedPath = $cfg.watchPath;
		}
		if ("OK" -eq $dialog.ShowDialog($this.form)) {
			$cfg.watchPath = $dialog.SelectedPath;
			$cfg.watch = $true;
		}
		else {
			$cfg.watch = $false;
		}
		SaveConfig;
		$this.Watch();
	}

	[string] _FindImage($dirPath, $option) {
		$path = $time = $null;
		$cfg = GetConfig;
		$maxCount = $cfg.maxFileEnum;
		$count = 0;
		foreach ($pngPath in [System.IO.Directory]::EnumerateFiles($dirPath, "*.png", $option)) {
			if ($null -eq $path) {
				$path = $pngPath;
				$time = [System.IO.File]::GetLastWriteTimeUtc($pngPath);
			}
			else {
				$pngTime = [System.IO.File]::GetLastWriteTimeUtc($pngPath);
				if ($pngTime -gt $time) {
					$path = $pngPath;
					$time = $pngTime;
				}
			}
			if ($count -ge $maxCount) { break; }
			$count++;
		}
		return $path;
	}

	[void] FindImage($dirPath) {
		if (($null -eq $dirPath) -or (![System.IO.Directory]::Exists($dirPath))) { return; }
		$path = $this._FindImage($dirPath, "TopDirectoryOnly");
		if ([string]::IsNullOrEmpty($path)) { $path = $this._FindImage($dirPath, "AllDirectories"); }
		if (![string]::IsNullOrEmpty($path)) { $this.SetImage($path); }
	}

	[string] SetNextImage() {
		if ($null -eq $this.image) { return $null; }
		$path = $time = $null;
		$curPath = $this.imagePath;
		$curTime = [System.IO.File]::GetLastWriteTimeUtc($curPath);
		$cfg = GetConfig;
		$maxCount = $cfg.maxFileEnum;
		$count = 0;
		$dir = [System.IO.Path]::GetDirectoryName($curPath);
		foreach ($pngPath in [System.IO.Directory]::EnumerateFiles($dir, "*.png")) {
			$pngTime = [System.IO.File]::GetLastWriteTimeUtc($pngPath);
			# 今の画像よりも古い中で一番新しい、ひとつ古い
			if ($pngTime -lt $curTime) {
				if (($null -eq $path) -or ($pngTime -gt $time)) {
					$path = $pngPath;
					$time = $pngTime;
				}
			}
			if ($count -ge $maxCount) { break; }
			$count++;
		}
		if ($null -ne $path) {
			$this.SetImage($path);
			return $curPath;
		}
		return $null;
	}

	[string] SetPrevImage() {
		if ($null -eq $this.image) { return $null; }
		$path = $time = $null;
		$curPath = $this.imagePath;
		$curTime = [System.IO.File]::GetLastWriteTimeUtc($curPath);
		$cfg = GetConfig;
		$maxCount = $cfg.maxFileEnum;
		$count = 0;
		$dir = [System.IO.Path]::GetDirectoryName($curPath);
		foreach ($pngPath in [System.IO.Directory]::EnumerateFiles($dir, "*.png")) {
			$pngTime = [System.IO.File]::GetLastWriteTimeUtc($pngPath);
			# 今の画像よりも新しい中で一番古い、ひとつ新しい
			if ($pngTime -gt $curTime) {
				if (($null -eq $path) -or ($pngTime -lt $time)) {
					$path = $pngPath;
					$time = $pngTime;
				}
			}
			if ($count -ge $maxCount) { break; }
			$count++;
		}
		if ($null -ne $path) {
			$this.SetImage($path);
			return $curPath;
		}
		return $null;
	}

	[void] SetImage($path) {
		$cfg = GetConfig;
		$path = [System.IO.Path]::GetFullPath($path);
		$bytes = [System.IO.File]::ReadAllBytes($path);

		$stream = New-Object System.IO.MemoryStream @(, $bytes);
		$img = New-Object System.Drawing.Bitmap($stream);
		$stream.Dispose();

		if ($null -ne $this.image) { $this.image.Dispose(); }
		$this.image = $img;
		$this.imagePath = $path;

		$stream = New-Object System.IO.MemoryStream @(, $bytes);
		$reader = New-Object System.IO.BinaryReader $stream;
		[void]$reader.ReadBytes(8 + 25);
		$tEXt = $reader.ReadBytes(4);
		[void]$reader.ReadBytes(4 + 11);
		$paramSize = ([int]$tEXt[0] -shl 24) + ([int]$tEXt[1] -shl 16) +
			([int]$tEXt[2] -shl 8) + $tEXt[3] - 11;
		$param = $reader.ReadBytes($paramSize);
		$reader.Dispose();
		$param = [System.Text.Encoding]::UTF8.GetString($param);
		$param = $param.Replace("`n", "`r`n");

		$info = "[ $($img.Width) x $($img.Height) ] $([System.IO.Path]::GetFileName($path))";

		$this.textArea.Text = "$info`r`n$param";

		if ($cfg.topmost -eq "Update") {
			$this.form.Topmost = $true;
			$this.form.Topmost = $false;
		}

		$this.canvas.Invalidate();
	}

	[void] DistImage($path) {
		$srcPath = $this.SetNextImage();
		if ([string]::IsNullOrEmpty($srcPath)) { $srcPath = $this.SetPrevImage(); }
		if ([string]::IsNullOrEmpty($srcPath)) {
			# 最後の振り分けで振り分け停止
			$srcPath = $this.imagePath;
			$this.keyDownDistImage = $false;
		}
		$dstPath = $path;
		if (![System.IO.Path]::IsPathRooted($dstPath)) {
			$dstPath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($srcPath), $dstPath);
		}
		if (![System.IO.Directory]::Exists($dstPath)) { [System.IO.Directory]::CreateDirectory($dstPath); }
		$dstPath = [System.IO.Path]::Combine($dstPath, [System.IO.Path]::GetFileName($srcPath));
		Move-Item $srcPath $dstPath -Force;
		if (!$this.keyDownDistImage) { $this.imagePath = $dstPath; }
	}

	[void] Dispose() {
		if ($null -ne $this.watcher) { $this.watcher.Dispose(); }
		if ($null -ne $this.image) { $this.image.Dispose(); }
		$this.form.Dispose();
	}
}

[System.Windows.Forms.Application]::EnableVisualStyles();
$imageViewer = New-Object GenImageViewer;
$imageViewer.InitializeForm();
$imageViewer.Watch();
$imageViewer.FindImage($config.watchPath);

Add-Type -Name Window -Namespace Console -MemberDefinition '
	[DllImport("Kernel32.dll")] public static extern IntPtr GetConsoleWindow();
	[DllImport("user32.dll")] public static extern void ShowWindow(IntPtr hWnd, Int32 nCmdShow);'
[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0);

[System.Windows.Forms.Application]::Run($imageViewer.form);
$imageViewer.Dispose();
