# [MaiNovel](../README.md) - [画像分類ツール](./ImageClassifier.md) (ImageClassifier)

画像分類ツールは AI が生成した数千枚単位の画像を、少しでも楽に分類するためのツールです。
数千枚の画像に AI にタグ付けをしてもらい、その結果を元に画像を分類することで、少しでも人が分類する作業を楽にします。

**現状は分類に適したタグ付けやタグ選択ができていないため、はずれの確率が低い画像から順に確認できる程度の効果しかありません。**

もし、良い Tagger や良いタグについての情報がありましたら、共有してもらえると嬉しいです。

# 使い方

Windows で ImageClassifier.bat と ImageClassifier.ps1 があれば動作します。

1. 分類したい画像を png 形式で適当なフォルダに集めます。
1. AI 画像学習などに使う Tagger などを使用して、png をタグ付けします。
	- png と同じ場所に同じ名前の txt ファイルでタグファイルを用意します。
	- AI 画像学習よりも多くのタグを必要とするため、タグ出力のしきい値を下げます。
	- タグの信頼度を結果に含めます。
	- [stable-diffusion-webui-wd14-tagger](https://github.com/toriato/stable-diffusion-webui-wd14-tagger) での設定例です。
		- Tagger の Batch from directory を png のあるパスに指定。
		- Output filename format: [name].[output_extension]
		- Action on exiting caption: 末尾に加える（Wife と Deepdanbooru の両方を使う場合）
		- Interrogator: wd14-convnext や deepdanbooru-v3-20211112-sdg-e28
		- しきい値: 0.0001
		- マッチしたタグの信頼度を結果に含める: 有効
		- アンダースコアの代わりにスペースを使用する: 有効
1. 複数の Interrogator を使用する場合は、タグファイルを生成した後に Interrogator を切り替えて、もう一度 Interrogate します。
	- 同じタグでは信頼度が高い方の値を使用します。
1. png とタグファイルをまとめたフォルダを、/Tool/ImageClassifier/ImageClassifier.bat にドラッグ＆ドロップするとサブフォルダに分類します。
	- 分類されなかった png は、other/ に振り分けられます。
	- タグとしきい値を変更したい場合は /Tool/ImageClassifier/ImageClassifier.ps1 の先頭にある ClassifyImage() の中を書き換えます。
1. 振り分け結果を確認しながら ClassifyImage() のしきい値などを調整して再振り分けします。
	- そのため、振り分け前にサブフォルダの png を削除し、png をコピーで振り分けます。
		- 振り分けに満足したら、親フォルダの png とタグファイルをまとめて消して、サブフォルダの png を利用します。
	- コピーでなく移動にしたい場合は、[IO.File]::Copy($this.pngPath, $dstPngPath, $true); を書き換えてください。
