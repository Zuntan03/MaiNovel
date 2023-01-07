# MaiNovel - README

MaiNovel は AI 技術を使って手軽にビジュアルノベルを作れるコンパクトなツールです。

AI 技術の発展で、誰でも手軽に内心を自由に表現できる未来が近づいています。<br>
そんな中で、まずはビジュアルノベルの作成がどれだけ手軽になるのかを、コンパクトに試してみました。

仕事などで自由時間が少なくても、絵や声優のスキルが無くても、ビジュアルノベルでの表現ができます。

## [**ノベルの実例はこちら**](https://yyy.wpx.jp/m/)

[こちら](https://yyy.wpx.jp/m/)でノベルの実例を確認できます。

## 最小ノベル

以下が最小のノベルです。[こちらで動作を確認できます。](https://yyy.wpx.jp/m/minimum/)

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

# はじめに

MaiNovel でノベルを作成するには、まず [セットアップガイド](./Document/SetupGuide.md) でノベルを動かしてみてください。<br>
ノベルを動かしてみて、ノベルの作成に興味を持てそうでしたら[チュートリアル](./Document/Tutorial.md) や [よくある質問と回答](./Document/FAQ.md) や [ノベル作成ガイド](./Document/NovelCreationGuide.md) もどうぞ。

ツール説明や、[ノベルファイルフォーマット](./Document/NovelFileFormat.md) は、最初は見なくても問題ありません。

* [セットアップガイド](./Document/SetupGuide.md)
* [チュートリアル](./Document/Tutorial.md)
* [よくある質問と回答](./Document/FAQ.md)
* [ノベル作成ガイド](./Document/NovelCreationGuide.md)
* ツール説明
	* [画像分類ツール](./Document/ImageClassifier.md)
* [ノベルファイルフォーマット](./Document/NovelFileFormat.md)

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

MaiNovel は [MIT License](./LICENSE.txt) です。

This software is released under the MIT License, see [LICENSE.txt](./LICENSE.txt).
