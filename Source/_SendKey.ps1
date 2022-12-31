Add-Type -ReferencedAssemblies System.Windows.Forms -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class Win32Wrapper {
	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	public static extern bool SetForegroundWindow(IntPtr hWnd);

	public static void SendKey(IntPtr hWnd, string key) {
		if(SetForegroundWindow(hWnd)){ SendKeys.SendWait(key); }
	}
}
"@

function SendKey( $processName, $titlePrefix, $key) {
	foreach ($process in (Get-Process -Name $processName)) {
		if ($process.MainWindowTitle.StartsWith($titlePrefix)) {
			[Win32Wrapper]::SendKey($process.MainWindowHandle, $key);
		}
	}
}
