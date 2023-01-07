# [MaiNovel](../README.md) - [チュートリアル](Tutorial.md)

MaiNovel のチュートリアルでは、コンテで音声を生成し、ノベルを動かすところまでを説明します。

ファイル名などのパスを記載する際に /NOVEL_NAME.json といった表記を使用します。<br>
/（スラッシュ）で開始するパスは主にノベル作成環境内の相対パスで、NOVEL_NAME はノベル作成時に指定した名前です。

# ノベル作成環境の用意

1. MaiNovel の展開先にある CreateNovel.bat をダブルクリックで実行します。
1. 画面の案内に沿って、英数字でノベルの名前を入力します。
	* ファイルやフォルダの名前に利用できる記号も使用できます。
	* 以降の説明ではここで入力したノベルの名前を NOVEL_NAME と表記します。
1. MaiNovel の展開先に、ノベル作成環境である NOVEL_NAME フォルダが生成されます。
	* この NOVEL_NAME フォルダは好きな場所に移動できます。

# コンテでの音声の生成

1. COEIROINK のインストール時に作成したショートカットか、COEIROINK 展開先の COEIROINKonVOICEVOX.exe を実行して、COEIROINK を立ち上げておきます。
1. /NOVEL_NAME/NOVEL_NAME.html を Chrome で開くと、以下のような表示がされます。<br>
![DefaultStoryboard](image/Tutorial/DefaultStoryboard.png)
1. /NOVEL_NAME/NOVEL_NAME.code-workspace で Visual Studio Code を立ち上げると、以下のダイアログが表示されますので、信頼します。<br>
![VsCodeWorkspaceTrust](image/Tutorial/VsCodeWorkspaceTrust.png)
1. Visual Studio Code のエクスプローラーで NOVEL_NAME.json を開くと、以下の画面になります。<br>
![DefaultVsCode](image/Tutorial/DefaultVsCode.png)<br>
README.md を右クリックし、「プレビューを開く」でドキュメントを確認できます。
1. Visual Studio Code でキーボードの「F5」を押すと、COEIROINK での音声の生成が開始されます。<br>
しばらくしてすべての音声の生成が終わると、Chrome の表示が更新されます。
1. Chrome のコンテで音声の再生ボタンを押すと、生成された音声を確認できます。
1. NOVEL_NAME.json の内容を書き換えてから再度「F5」を押すと、書き換えた部分のみ音声が再生成された後に、Chrome の表示が更新されます。
	* NOVEL_NAME.json はサンプルを兼ねています。<br>
	最初は先頭にある「実験用のシーン」を書き換えて、色々試してみてください。

# ノベルを動かす

1. 文章と音声が一段落したら、COEIROINK を立ち上げた状態で /RegenerateWav.bat を実行して、ノベル用の音声をすべて再生成します。
1. 音声の生成が終わったら /Preview.bat を実行し、「 http://127.0.0.1/Temporary_Listen_Addresses/ 」と書かれている部分を Ctrl + 左クリックすると、Web ブラウザでノベルを確認できます。
1. /png/s[シーン番号]/s[シーン番号]m[メッセージ番号].png といった画像を用意し、ブラウザをリロードすると、指定したシーンのメッセージで画像が表示されます。<br>
例：/png/s01/s01m02.png は、ふたつめのシーンのみっつめのメッセージで表示されます。

# サンプルノベルの紹介

一通りの機能を使用しているサンプルノベルです。<br>
以下のサンプルの内容を見つつ、[動作を確認してみてください](https://yyy.wpx.jp/m/template/)。

<details>
<summary>サンプルの内容</summary>

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
