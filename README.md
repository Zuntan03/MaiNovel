# MaiNovel - README

MaiNovel は AI 技術を使って手軽にビジュアルノベルを作れるコンパクトなツールです。

AI 技術の発展で、誰でも手軽に内心を自由に表現できる未来が近づいています。<br>
そんな中で、まずはビジュアルノベルの作成がどれだけ手軽になるのかを、コンパクトに試してみました。

仕事などで自由時間が少なくても、絵や声優のスキルが無くても、ビジュアルノベルでの表現ができます。

## [**ノベルの実例はこちら**](https://yyy.wpx.jp/m/)

まずは[こちら](https://yyy.wpx.jp/m/)でサンプルでないノベルの実例を確認してください。

## 最小ノベルサンプル

[最小ノベルのサンプルです。リンク先で動作を確認できます。](https://yyy.wpx.jp/m/minimum/)

```json
{
    "config": {
        "title": "最小のノベル",
        "voiceName": "ろさちゃん",
        "credit": "COEIROINK: 汎用式概念"
    },
    "voices": [ { "voiceName": "ろさちゃん", "ciiStyleId": 327965129 } ],
    "scenes": [
        {
            "sceneName": "最小のシーン",
            "messages": [ "シーンがひとつで、メッセージもひとつの、最小のノベルの例です。おわり。" ]
        }
    ]
}
```

## テンプレートノベルサンプル

[テンプレートノベルのサンプルです。リンク先で動作を確認できます。](https://yyy.wpx.jp/m/template/)

一通りの機能を使用していますので、見て面白いものではありません。<br>
以下のノベルの内容を見ながら動作を確認しないと、意味不明に見えます。<br>
複雑に見えますがすべて理解する必要はありません。

<details>
<summary>テンプレートノベルサンプルの内容</summary>

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
                    "ciiSpeed": 1.5
                },
                {
                    "text": "COEIROINKが生成する音声の音量を変えられます。",
                    "ciiVolume": 0.3
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
                    "ciiText": "読み上げる文章と表示する文章を、このように違うものにできます。"
                },
                {
                    "text": "どこからでもシーン移動ができますので、png/s02/s02m00.png のようにシーンの最初には画像を用意してください。",
                    "ciiText": "どこからでもシーン移動ができますので、シーンの最初には画像を用意してください。"
                },
                {
                    "text": "画像は png/s00/s00m00.png 形式でファイル名が一致したものを自動で表示しますが、別の指定方法もあります。\"imageName\": \"s01m00\" は画像のファイル名での指定の例です。",
                    "ciiText": "画像はファイル名が一致したものを自動で表示しますが、別の指定方法もあります。これは画像のファイル名での指定の例です。",
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
                    "ciiText": "コンフィグで和文タイトルの設定や、コエイロインク や マイコエイロインク のクレジットの更新を忘れないようにしてください。"
                },
                {
                    "text": "なにか困ったことがあったら、README.md を見てください。",
                    "ciiText": "なにか困ったことがあったら、リードミーを見てください。"
                },
                {
                    "text": "Visual Studio Codeのエクスプローラーで README.md を右クリックして、「プレビューを開く (Ctrl + Shit + V)」と読みやすいです。",
                    "ciiText": "ビジュアルスタジオコードのエクスプローラーでリードミーを右クリックして プレビューを開く と読みやすいです。"
                },
                "最後にオプションを盛ってみます。",
                {
                    "voiceName": "ろさちゃん 囁",
                    "text": "お も て な し。",
                    "ciiText": "おぉ もぉ てぇ なぁ しぃ。",
                    "ciiVolume": 1.5,
                    "ciiSpeed": 1.5,
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


# はじめに

MaiNovel でノベルを作成するには、まず [セットアップガイド](Document/SetupGuide.md) と [チュートリアル](Document/Tutorial.md) でノベルを動かしてみてください。<br>
ノベルを動かしてみて、ノベルの作成に興味を持てそうでしたら [ノベル作成ガイド](Document/NovelCreationGuide.md) もどうぞ。

[ノベルファイルフォーマット](Document/NovelFileFormat.md) は、最初は見なくても問題ありません。

* [セットアップガイド](Document/SetupGuide.md)
* [チュートリアル](Document/Tutorial.md)
* [ノベル作成ガイド](Document/NovelCreationGuide.md)
* [ノベルファイルフォーマット](Document/NovelFileFormat.md)

# 動作環境

* Windows 10 以降の Windows PC
	* 動作確認では Windows 11 を使用しています。
	* ノベルの再生は Android 版の Chrome でも動作確認しています。
* [COEIROINK](https://coeiroink.com/)
	* ライセンスが使いやすく、自作の音声合成を利用できる無料の音声合成ソフトです。
		* 商用やゾーニングの必要なコンテンツでも無料で使える[利用規約](https://coeiroink.com/terms)です。 
		* [MYCOEIROINK](https://coeiroink.com/mycoeiroink) で音声合成を自作できます。
		* [他作の MYCOEIROINK](https://coeiroink.com/mycoeiroink#app) も利用できます。<br>ただし、利用規約がそれぞれ異なりますので、ご注意ください。
	* 動作確認では COEIROINK-GPU-v.1.6.0(Windows) 版を使用しています。
* [Visual Studio Code](https://code.visualstudio.com/)
	* ノベルの執筆に利用します。
* [Google Chrome](https://www.google.com/intl/ja_jp/chrome/)
	* ノベルの再生に利用します。
* [お好みの画像生成 AI](https://www.google.com/search?q=AI%E7%94%BB%E5%83%8F%E7%94%9F%E6%88%90)
	* 画像生成 AI は進歩がとても激しいため、自身の希望と状況にあった画像生成 AI をご利用ください。

# ライセンス

MaiNovel は [MIT License](LICENSE.txt) です。

This software is released under the MIT License, see [LICENSE.txt](LICENSE.txt).
