# [MaiNovel](../README.md) - [ノベルファイルフォーマット](NovelFileFormat.md)

Novel ファイルは以下の構造をしています。

* [Novel](#novel)
	* [Config](#config)
	* [Voice](#voice)[]
	* [Scene](#scene)[]
		* [Message](#message)[]

## Novel

* Config config
	* Novel の設定です。
* Voice[] voices
	* Novel で使う Voice の配列です。
* Scene[] scenes
	* Novel 内の各 Scene の配列です。

## Config

* string title
	* ノベルの表示タイトルです。日本語を使用できます。
* string voiceName
	* 音声合成に使用する Voice の名前です。Scene と Message で voiceName を指定しなかった場合に、この voiceName を使用します。
* string sceneCodeFormat
	* Scene 番号の桁数を 0 を並べて指定します。例えば "000" だと 3桁で、省略時は "00" の 2桁です。
* string messageCodeFormat
	* Message 番号の桁数を 0 を並べて指定します。例えば "000" だと 3桁で、省略時は "00" の 2桁です。
* string imageFormat
	* ノベルで使用する画像のデフォルトの拡張子です。省略時は "png" です。
* string audioFormat
	* ノベルで使用する音声の拡張子です。省略時は "wav" です。
* int audioInterval;
	* Message の間のデフォルトの待ち時間をミリ秒で指定します。省略時は 1000 です。Scene と Message で audioInterval を指定しなかった場合に、この audioInterval を使用します。
* string credit
	* ノベルの下部に表示される権利表記です。省略時は空文字列です。
* float ciiVolume
	* COEIROINK での音声合成に使用する音量で、Scene と Message の ciiVolume と乗算されます。省略時は 1.0 です。
* float ciiSpeed
	* COEIROINK での音声合成に使用する話速で、Scene と Message の ciiSpeed と乗算されます。省略時は 1.0 です。

## Voice

* string voiceName
	* 声の名前です。ノベル執筆に使いやすい名前を適当に定義します。
* long ciiStyleId
	* 声を COEIROINK の styleId で指定します。
	styleId は COEIROINK インストール先の speaker\_info/キャラクターハッシュフォルダ/metas.json で調べます。

## Scene

* string sceneName
	* Scene の表示名です。日本語を使用できます。
* string voiceName
	* 音声合成に使用する Voice の名前です。Message で voiceName を指定しなかった場合に、この voiceName を使用します。
* int audioInterval;
	* Message の間のデフォルトの待ち時間をミリ秒で指定します。Message で audioInterval を指定しなかった場合に、この audioInterval を使用します。
* float ciiVolume
	* COEIROINK での音声合成に使用する音量で、Config と Message の ciiVolume と乗算されます。省略時は 1.0 です。
* float ciiSpeed
	* COEIROINK での音声合成に使用する話速で、Config と Message の ciiSpeed と乗算されます。省略時は 1.0 です。
* Message[] messages
	* Scene 内の Message の配列です。

## Message

Message はオブジェクトとして定義する他に、文字列でも定義できます。 
つまり、 `{ "text": "文章" },` と `"文章",` は同じ意味になります。

* string text
	* Message の表示文章です。通常は音声合成にも利用します。
* string insertHTML
	* text の前に挿入される HTML です。読み上げの対象にはなりません。
* string voiceName
	* 音声合成に使用する Voice の名前です。
	省略時は Scene や Config の voiceName を使います。
* int audioInterval
	* Message の間のデフォルトの待ち時間をミリ秒で指定します。
* string imageName
	* 異なる Scene 番号や Message 番号の画像を使用する際に指定します。
	デフォルトで "s01m02" を指定すると "png/s01/s01m02.png" を表示します。
	"m03" といった表記では、同じ Scene の異なる Message の画像を表示します。
* string imagePath
	* "png/s01/s01m02.png" といった表記で、画像への相対パスを指定します。
	config.imageFormat 以外のフォーマットを指定できますが、完成時には画像を手動でコピーする必要があります。
	imagePath を指定していると imageName は無視されます。
* float ciiVolume
	* COEIROINK での音声合成に使用する音量で、Config と Scene の ciiVolume と乗算されます。省略時は 1.0 です。
* float ciiSpeed
	* COEIROINK での音声合成に使用する話速で、Config と Scene の ciiSpeed と乗算されます。省略時は 1.0 です。
* string ciiText
	* COEIROINK での音声合成に使用する文章です。
	text による表示とは異なる読み上げをしたい場合に利用します。
