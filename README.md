# ZineBrewer

ZineBrewer converts Kramdown (=exhanced Markdown) document to HTML for Shoeisha Web Media.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zine_brewer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install zine_brewer

## Usage

    $ zine_brewer [kramdown_document_filename]

* The header part is converted and written out as "proof/header.txt".
* The body part is converted and written out as "proof/body.txt".

## Enhanced Notation in ZineBrewer

ここでは、Kramdown（拡張Markdown）に加えて記述可能にした、ZineBrewer向けの記法を説明します。Kramdownの記法は、こちら（[クイックリファレンス](https://kramdown.gettalong.org/quickref.html)／[詳細文法](https://kramdown.gettalong.org/syntax.html)）をご覧ください。

ZineBrewerで扱う原稿は「ヘッダー」と「本文」に分かれます。以下ではそれぞれ説明します。

なお、ZineBrewerは変換したヘッダー、本文をそれぞれheader.txt、body.txtとして、proofフォルダに格納します。

### ヘッダー

ヘッダーは6つの項目からなります。各項目は空行を挟んで記述してください。以下の方法で記述を省略することもできます。

* `---`と書く
* 以下省略。例えば、コーナー名とタイトルだけ書いておき、以下は何も書かない（`---`も書かない）ということができます。ただし、以下省略でも、**最後の`■記事ID■：0000`だけは書くようにします。**

ヘッダーの記述項目:
```
[コーナー名]

[タイトル]

[リード]

[リード横に表示する画像のファイル名]

[著者名]

[追加CSS]

[■記事ID■：0000]
```

ヘッダー記述例。コーナー名を`---`で省略、追加CSSは以下省略しています。
```
---

原稿はZineBrewerで書こう！ スタイルも適用できるよ

　もともと、Markdown原稿にCSSスタイルを書き込んでおく方法はないかと思い、  
見つけたのがKramdownです。文字単位・段落単位でidやclass、各種属性を記述  
しておくことができました。ただし、Kramdownが出力するHTMLは、翔泳社の  
記事配信システムが受け付けるHTMLフォーマットとは少し異なる部分があります。  
そこで、Kramdownを拡張し、翔泳社の記事配信システムが受け付けるHTMLを出力  
するようにしたツールが、ZineBrewerです。

1234_title.png

市古 明典

■記事ID■：1234

<%-- page -->

（以下、本文）
```

ヘッダーと本文の境界には、本文ページの起こしを指示する`<%-- page -->`を記述します。

**【注意】ヘッダーの最後に記述する`■記事ID■：0000`は、原則として記述必須です。**例外として、原稿を入れているフォルダの名前を記事ID（「1234」など）にしている場合には省略できます。

上記例をZineBrewerで変換した場合、ヘッダーは次のように出力されます（proof/header.txt）。

```
［タイトル］
原稿はZineBrewerで書こう！ スタイルも適用できるよ

［リード］
<p>　もともと、Markdown原稿にCSSスタイルを書き込んでおく方法はないかと思い、  
見つけたのがKramdownです。文字単位・段落単位でidやclass、各種属性を記述  
しておくことができました。ただし、Kramdownが出力するHTMLは、翔泳社の  
記事配信システムが受け付けるHTMLフォーマットとは少し異なる部分があります。  
そこで、Kramdownを拡張し、翔泳社の記事配信システムが受け付けるHTMLを出力  
するようにしたツールが、ZineBrewerです。</p>

［タイトル画像］
1234_title.png

［著者クレジット］
市古 明典
```

### 本文

#### ■図の書き方

図は「拡大なし」「拡大あり」「拡大あり（lightbox）」「ハイパーリンク」「プロフィール」の5種類を記述できます。いずれも`<<Fig-●>>`（●にはアルファベット**大文字**1字が入る）から書き出します。

また、**記述の後には必ず空行を入れてください**（空行が指示の終わりを表します）。

(1) 拡大なし――src以外は省略可能。**widthとheightはどちらかを指定**しておけば、それに合わせて拡大／縮小表示します（他の種類も同様）:
```
<<Fig_N>>
src: [画像ファイル名] ※例 1234_fig.png
widrh: [画像を表示するときの幅を指定] ※例 400px
height: [画像を表示するときの高さを指定] ※例 300px
cap: [キャプション] ※例 2020年調査のグラフ
```

(2) 拡大あり――src以外は省略可能。大きな画像をアップしておき、widthやheightを使って小さく表示させます。なお、キャプションに自動的に［画像クリックで拡大表示］と表示されます。:
```
<<Fig_A>>
src: [画像ファイル名] ※例 1234_fig.png
widrh: [画像を表示するときの幅を指定] ※例 400px
height: [画像を表示するときの高さを指定] ※例 300px
cap: [キャプション] ※例 2020年調査のグラフ
```

(3) 拡大あり（lightbox）――src以外は省略可能。ズーム表示を使いたいときに使用します。やはり、大きな画像をアップしておき、widthやheightを使って小さく表示させます:
```
<<Fig_Z>>
src: [画像ファイル名] ※例 1234_fig.png
widrh: [画像を表示するときの幅を指定] ※例 400px
height: [画像を表示するときの高さを指定] ※例 300px
cap: [キャプション] ※例 2020年調査のグラフ
```

(4) ハイパーリンク――srcとhref以外は省略可能。画像をクリックしたときに、hrefで指定したWebページへジャンプさせます:
```
<<Fig_H>>
src: [画像ファイル名] ※例 1234_book01.png
href: [リンク先のURL] ※例 https://www.amazon.co.jp/dp/4798142417
widrh: [画像を表示するときの幅を指定] ※例 200px
height: [画像を表示するときの高さを指定] ※例 150px
cap: [キャプション] ※例 書籍『スターティングGo言語』
```

(5) プロフィール――人物の写真にプロフィールを付けたいときに使う記述方法です。名前とふりがなは、変換後「名前（ふりがな）氏」という表示になります。また、画像の幅を600pxにすると、プロフィールと幅がそろいます。プロフィールの肩書きやプロフィールの行頭に、半角空白でインデントを入れることが必須です。
```
<<Fig_P>>
src: [画像ファイル名] ※例 1234_ichigo.jpg
widrh: [画像を表示するときの幅を指定] ※例 600px
height: [画像を表示するときの高さを指定] ※例 400px
name: [名前] ※例 市古 明典
huri: [ふりがな] ※例 いちご あきのり
cap: |
  肩書き
  プロフィール
```

#### テクニック

(1) `cap:`（キャプション）は、次のように書くと途中改行を入れられます。各行の先頭には半角空白によるインデントを必ず行います。

```
cap: |
  1行目
  2行目
```

(2) 次のように`imgs:`を使うと、複数の画像を並べて表示できます。特に、`width:`（と画像間のすきま）の合計が670px以内の場合、PC画面では横に並べて表示されます。

```
<<Fig_H>>
imgs:
  - src: 1234_book01.png
    href: https://www.amazon.co.jp/dp/4798154350
    width: 200px
  - src: 1234_book02.png
    href: https://www.amazon.co.jp/dp/4798154369
    width: 200px
  - src: 1234_book03.png
    href: https://www.amazon.co.jp/dp/4798161888
    width: 200px
cap: 『紛争事例に学ぶ、ITユーザの心得』3部作
```

(3) `src:`に記述するファイル名の先頭にある「1234_」という記事IDを表す部分は省略できます。代わりに、ヘッダに記述した`■記事ID■：`で記述した番号が入ります。`■記事ID■：`がない場合にも、原稿のフォルダ名が記事IDになっていればその番号が入ります。

```
（ヘッダ）
……

■記事ID■：1234

<%-- page -->

（本文）
……

<<Fig_N>>
src: fig.png    <--- 1234_fig.png と書いたのと同じになる
```

#### ■コラムの書き方

コラム（囲み）は、`===column`と`==/column`で挟むことで記述できます。

```
（本文）

===column
#### 見出しも入れられます

　コラム本文……
==/column
```

`===column`に対してスタイルを指示できます。例えば、次のように書くと囲み罫線なしで角丸、地色をベージュにした囲みにできます（スタイルの記述方法は後述）。

```
（本文）

{:%border:none; %border-radius:8px; %background-color:#ffffe6;}
===column
#### コラム見出し

コラム本文……。
==/column
```

#### ■divブロックの書き方

ある範囲に対してスタイルを当てたいときなどには、divブロックをつくって、それに対してスタイルを指示します。divブロックは`===div`と`==/div`で挟むことでつくれます。

例えば、本文のある範囲の地にグレーを敷きたい場合、次のように書きます。

```
（本文）

{%background-color:#e6e6e6; %padding:1em;}
===div
　本文テキスト。もちろん図なども入れられます。

<<Fig_N>>
src: 1234_fig.png
width: 450px

==/div
```

#### ■画像回り込みの書き方

divブロックの応用として、本文テキストの画像回り込み指定があります。スタイル指定と合わせて、次に用に記述します。

```
```

#### ■スタイルの書き方

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ZineBrewer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/akinori-ichigo/zine_brewer/blob/master/CODE_OF_CONDUCT.md).
