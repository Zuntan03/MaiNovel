# [MaiNovel](../README.md) - [セットアップガイド](./SetupGuide.md)

MaiNovel のセットアップ手順です。

* [Google Chrome](https://www.google.com/intl/ja_jp/chrome/) をインストールします。
* [Visual Studio Code](https://code.visualstudio.com/) をインストールします。
	* 拡張機能の [PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell) をインストールします。 
* [COEIROINK](https://coeiroink.com/) は Zip を適当なフォルダに展開します。
	* [MYCOEIROINK](https://coeiroink.com/mycoeiroink) の『[ろさちゃん](https://senolosachan.com/download-%e2%94%82-type-%cf%87/)』をインストールします。
* MaiNovel は Zip を適当なフォルダに展開します。
* [画像生成 AI](https://www.google.com/search?q=%E7%94%BB%E5%83%8F%E7%94%9F%E6%88%90+AI) を利用できるようにします（後回しにできます）。
* セットアップが終わったら、[チュートリアル](./Tutorial.md) に進みます。

# Google Chrome のインストール

* [Google Chrome 公式サイト](https://www.google.com/intl/ja_jp/chrome/)で「Chrome をダウンロード」して、インストールします。
	* Chrome を Windows のデフォルトのブラウザ（*.html の既定のアプリ）に設定すると、ノベルの作成が少し楽になります。

# Visual Studio Code のインストール

__！！とりあえず動かしてみたいの方は、Visual Studio Code のインストールを後回しにできます。！！__

* [Visual Studio Code 公式サイト](https://code.visualstudio.com/)で「Download for Windows Stable Build」して、インストールします。

Visual Studio Codeをインストールしたら起動して、拡張機能をインストールします。

* ウィンドウ左の縦に並ぶアイコンの「拡張機能 (Ctrl + Shit + X)」を開きます。
* 上部の「Marketplace で拡張機能を検索する」に「jap」と入力して、「[Japanese Language Pack for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=MS-CEINTL.vscode-language-pack-ja)」拡張を「インストール」し、画面右下に表示される「Change Language and Restart」で再起動します。 <br>
![VsCodeJaExtension](image/SetupGuide/VsCodeJaExtension.png)
* 同様に拡張機能で「pow」と入力して、Microsoft の 「[PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)」拡張を「インストール」します。 <br>
その後に表示される「Install PowerShell 7」をインストールする必要はありません。

拡張機能のインストールを終えたら、Visual Studio Codeの設定をします。
設定画面はメニューの「ファイル > ユーザー設定 > 設定 (Ctrl + ,)」で開きます。

* 「よく使用するもの」にある「Editor: Render Whitespace」を「boundary」に設定します。
* 「よく使用するもの」にある「Editor: Word Wrap」を「on」に設定します。
* 「テキスト エディター > 書式設定」にある「Format On Save」を有効にします。

設定が終了したら、Visual Studio Code を閉じます。

## 他の役立ちそうな Visual Studio Code 拡張機能（オプション）

* ノベルファイルは階層が深くなりがちなので、「[indent-rainbow](https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow)」による階層の色分けが役立ちます。
* アイコンを変えると華やかになります。
	* 「[vscode-icons](https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons)」か「[Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme)」をお好みで。

Visual Studio Code の拡張機能は、ダウンロード数が100万(1M)を超えるような、人気のあるものを利用するのがおすすめです。

# COEIROINK のインストール

* [COEIROINK 公式サイト](https://coeiroink.com/) の「[DOWNLOAD PAGE](https://coeiroink.com/download)」の指示に沿って最新の COEIROINK GPU(Windows) 版をインストールします。
* インストール先にある「COEIROINKonVOICEVOX.exe」を実行すると、COEIROINK が立ち上がります。
* 起動シーケンスを終えたら、適当な文章を入力して音声の再生ができることを確認します。
	* COEIROINK の音声の再生で問題が発生するようでしたら、公式の「[Q & A](https://coeiroink.com/q_and_a)」を確認してください。
	* COEIROINK の GPU 版が利用できないようでしたら、CPU 版を利用します。
* 音声の再生を確認できたら COEIROINK を閉じて、「COEIROINKonVOICEVOX.exe」のショートカットを適当な場所に作成します。

## COEIROINK に MYCOEIROINK を追加

MaiNovel のサンプルで使用している [MYCOEIROINK](https://coeiroink.com/mycoeiroink) の『[ろさちゃん](https://senolosachan.com/download-%e2%94%82-type-%cf%87/)』をインストールします。

「ろさちゃん」は以前に確認した範囲では品質が高く、商用利用やゾーニングが必要なコンテンツでの利用が可能な MYCOEIROINK です。
ただし、 [日々新しい MYCOEIROINK が登録](https://coeiroink.com/mycoeiroink#app)されていますので、同様の手順でお好みの音声合成を追加してご利用ください。

* [ろさちゃん配布ページ](https://senolosachan.com/download-%e2%94%82-type-%cf%87/) の下部にある「MYCOEIROINK」から「ロサちゃん音源（統合版）」をダウンロードします。
* Zip の展開先にある「50c08f30-c8cd-11ec-8ab1-0242ac1c0002」といったハッシュ値フォルダを、COEIROINKの展開先にある「speaker_info」フォルダに移動します。<br>
デフォルトでインストールされている「つくよみちゃん」の「3c37646f-3881-5374-2a83-149267990abc」といったハッシュ値フォルダに並べるようにします。<br>
![MycoeiroinkFolder](image/SetupGuide/MycoeiroinkFolder.png)
* 「COEIROINKonVOICEVOX.exe」を起動しなおすと、「ろさちゃん」が利用できるようになります。

# MaiNovel のインストール

* [MaiNovel の Release ページ](https://github.com/Zuntan03/MaiNovel/releases) から最新の「MaiNovel-v*.zip」をダウンロードして、適当なフォルダに展開します。
	* 浅めのフォルダ階層で、スペースを含まない、英数字のみのパスだと安心です。

# 画像生成 AI の用意

画像生成 AI を、今セットアップする必要はありません。
画像生成 AI は進歩がとても激しいため、自身の希望と状況にあった[画像生成 AI](https://www.google.com/search?q=%E7%94%BB%E5%83%8F%E7%94%9F%E6%88%90+AI)をご利用ください。

# とりあえず動かしてみる

1. CreateNovel.batを実行してノベルの名前をつけると、その名前のノベルのフォルダができます。
1. COEIROINKを立ち上げて、ノベルの RegenerateWav.bat を実行すると音声が生成されます。
1. 音声が生成されたらノベルの Preview.bat を実行して、表示される URL を Ctrl+左クリック すると動いているのを確認できます。
1. ノベルの ノベル名.json の文書を書き換えてみたり、Sample.json から一部をコピペしてみたり、画像を用意してみたりしてください。<br>
Sample.json の動作は、[こちらで確認できます](https://yyy.wpx.jp/m/template/)。

<details>
<summary>ノベル名.json の内容</summary>

```json
{
    "config": {
        "title": "ノベル名",
        "voiceName": "ろさちゃん",
        "imageFormat": "png",
        "audioFormat": "wav",
        "credit": "<a href='https:\/\/coeiroink.com\/' target='_blank'>COEIROINK</a>: <a href='https:\/\/senolosachan.com\/character\/' target='_blank'>汎用式概念</a>"
    },
    "voices": [
        { "voiceName": "ろさちゃん", "ciiStyleId": 327965129 }
    ],
    "scenes": [
        {
            "sceneName": "",
            "messages": [
                "このファイルに、AIに話させたいことを書きます。",
                "画像は自動で表示します。png/s00/s00m00.pngが最初に表示される絵で、png/s00/s00m01.pngがあれば2番めのこのメッセージで表示します。",
                "COEIROINKを立ち上げてRegenerateWav.batを実行すると、音声が生成されます。",
                "Wavファイルを生成したらPreview.batを実行して、表示されるURLをCtrl+左クリックでノベルを確認できるよ。",
                "おためしで興味を持てたら、ドキュメントのチュートリアルもやってみてね。",
                "Sample.jsonではいろんな機能を紹介しているので、コピペして試してみてね。",
                "最後のメッセージの後ろにはカンマを付けてはいけないので、気をつけてね。"
            ]
        }
    ]
}
```
</details>

<details>
<summary>Sample.json の内容</summary>

```json
{
    "config": {
        "title": "テンプレート",
        "voiceName": "ろさちゃん",
        "credit": "COEIROINK: 汎用式概念"
    },
    "voices": [
        { "voiceName": "ろさちゃん", "ciiStyleId": 327965129 },
        { "voiceName": "ろさちゃん 囁", "ciiStyleId": 1624935238 }
    ],
    "scenes": [
        {
            "sceneName": "実験用のシーン",
            "messages": [
                "実験用のシーンを最初に用意しました。このシーンを編集して、いろいろ試してください。",
                "テキストだけのメッセージを追加します。",
                {
                    "text": "オプション指定のあるメッセージを追加します。",
                    "voiceName": "ろさちゃん 囁"
                }
            ]
        },
        {
            "sceneName": "はじまりのシーン",
            "messages": [
                "ここにテキストを記載すると読み上げます。",
                "このシンプルなテキストのみの記法は、テキストをたくさん書くのに向いています。",
                {
                    "text": "特殊なオプションは、このように指定します。この例は、ボイスをささやき声にします。",
                    "voiceName": "ろさちゃん 囁"
                },
                {
                    "text": "COEIROINKが生成する音声の読み上げ速度を変えられます。",
                    "gvSpeed": 1.5
                },
                {
                    "text": "COEIROINKが生成する音声の音量を変えられます。",
                    "gvVolume": 0.3
                },
                {
                    "text": "次のメッセージまでの待ち時間をミリ秒で設定する例です。シーンの合間にひと呼吸をいれますね。",
                    "audioInterval": 3000
                }
            ]
        },
        {
            "sceneName": "なかのシーン",
            "voiceName": "ろさちゃん 囁",
            "messages": [
                "このシーンは、シーン全体をささやき声で読み上げる設定をしています。",
                {
                    "text": "このように表示する文章と、読み上げる文章を、違うものにできます。",
                    "gvText": "読み上げる文章と表示する文章を、このように違うものにできます。"
                },
                {
                    "text": "どこからでもシーン移動ができますので、png/s02/s02m00.png のようにシーンの最初には画像を用意してください。",
                    "gvText": "どこからでもシーン移動ができますので、シーンの最初には画像を用意してください。"
                },
                {
                    "text": "画像は png/s00/s00m00.png 形式でファイル名が一致したものを自動で表示しますが、別の指定方法もあります。\"imageName\": \"s01m00\" は画像のファイル名での指定の例です。",
                    "gvText": "画像はファイル名が一致したものを自動で表示しますが、別の指定方法もあります。これは画像のファイル名での指定の例です。",
                    "imageName": "s01m00"
                },
                {
                    "text": "同じシーンならメッセージ番号でも指定できます。この場合 m00 が s02m00 になります。",
                    "imageName": "m00"
                }
            ]
        },
        {
            "sceneName": "おわりのシーン",
            "messages": [
                {
                    "text": "相対パスでの画像の指定もできます。",
                    "imagePath": "png/s01/s01m00.png"
                },
                "ノベルファイル先頭のコンフィグで、オプションの初期値を設定できます。",
                {
                    "text": "コンフィグで和文タイトルの設定や、COEIROINK や MYCOEIROINK のクレジットの更新を忘れないようにしてください。",
                    "gvText": "コンフィグで和文タイトルの設定や、コエイロインク や マイコエイロインク のクレジットの更新を忘れないようにしてください。"
                },
                {
                    "text": "なにか困ったことがあったら、README.md を見てください。",
                    "gvText": "なにか困ったことがあったら、リードミーを見てください。"
                },
                {
                    "text": "Visual Studio Codeのエクスプローラーで README.md を右クリックして、「プレビューを開く (Ctrl + Shit + V)」と読みやすいです。",
                    "gvText": "ビジュアルスタジオコードのエクスプローラーでリードミーを右クリックして プレビューを開く と読みやすいです。"
                },
                "最後にオプションを盛ってみます。",
                {
                    "voiceName": "ろさちゃん 囁",
                    "text": "お も て な し。",
                    "gvText": "おぉ もぉ てぇ なぁ しぃ。",
                    "gvVolume": 1.5,
                    "gvSpeed": 1.5,
                    "imageName": "s00m00",
                    "audioInterval": 2000
                },
                {
                    "text": "おしまい。",
                    "insertHTML": "<a href='https:\/\/github.com\/Zuntan03\/MaiNovel' target='_blank'>MaiNovel<\/a> で作りました。"
                }
            ]
        }
    ]
}
```
</details>

# セットアップが完了したら

動作を確認してみて、ノベルの作成に興味を持てそうだったら [チュートリアル](./Tutorial.md) に進みます。

**[Visual Studio Code のインストール](#visual-studio-code-のインストール) を後回しにしていたのなら、[チュートリアル](./Tutorial.md) に進む前にインストールしてください。**
