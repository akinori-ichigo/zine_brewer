# ZineBrewer

ZineBrewer converts Kramdown (=exhanced Markdown) document to HTML for a web media.

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

As the converting command:

    $ zine_brewer [kramdown_document_filepath]

As the converting server:

    $ zine_brewing_server

When you run the command above,
or send kramdown_document_filepath to the zine_brewing_server,
the convertion is done as below.

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

**なお、ヘッダーの最後に記述する`■記事ID■：0000`は、原則として記述必須です。** 例外として、原稿を入れているフォルダの名前を記事ID（「1234」など）にしている場合には省略できます。

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

本文をHTMLに変換したファイルは、proof/body.txtとして出力されます。

#### ■ページの起こし

**本文の各ページの先頭には、ページの起こしとして必ず`<%-- page -->`を記述してください。** 1ページ目の起こしは、ヘッダーとの境界にもなります。

```
（ヘッダー）
……

■記事ID■：1234

<%-- page -->

本文1ページ目

<%-- page -->

本文2ページ目

<%-- page -->

本文3ページ目
```

#### ■図の書き方

図は「拡大なし」「拡大あり」「拡大あり（lightbox）」「ハイパーリンク」「プロフィール」の5種類を記述できます。いずれも`<<Fig-●>>`（●にはアルファベット**大文字**1字が入る）から書き出します。

また、**記述の後には必ず空行を入れてください**（空行が指示の終わりを表します）。

(1) 拡大なし――src以外は省略可能。**widthとheightはどちらかを指定**しておけば、それに合わせて拡大／縮小表示します（他の種類も同様）:
```
<<Fig_N>>
src: [画像ファイル名] ※例 1234_fig.png
width: [画像を表示するときの幅を指定] ※例 400px
height: [画像を表示するときの高さを指定] ※例 300px
cap: [キャプション] ※例 2020年調査のグラフ
```

(2) 拡大あり――src以外は省略可能。大きな画像をアップしておき、widthやheightを使って小さく表示させます。なお、キャプションに自動的に［画像クリックで拡大表示］と表示されます。:
```
<<Fig_A>>
src: [画像ファイル名] ※例 1234_fig.png
width: [画像を表示するときの幅を指定] ※例 400px
height: [画像を表示するときの高さを指定] ※例 300px
cap: [キャプション] ※例 2020年調査のグラフ
```

(3) 拡大あり（lightbox）――src以外は省略可能。ズーム表示を使いたいときに使用します。やはり、大きな画像をアップしておき、widthやheightを使って小さく表示させます:
```
<<Fig_Z>>
src: [画像ファイル名] ※例 1234_fig.png
width: [画像を表示するときの幅を指定] ※例 400px
height: [画像を表示するときの高さを指定] ※例 300px
cap: [キャプション] ※例 2020年調査のグラフ
```

(4) ハイパーリンク――srcとhref以外は省略可能。画像をクリックしたときに、hrefで指定したWebページへジャンプさせます:
```
<<Fig_H>>
src: [画像ファイル名] ※例 1234_book01.png
href: [リンク先のURL] ※例 https://www.amazon.co.jp/dp/4798142417
width: [画像を表示するときの幅を指定] ※例 200px
height: [画像を表示するときの高さを指定] ※例 150px
cap: [キャプション] ※例 書籍『スターティングGo言語』
```

(5) プロフィール――人物の写真にプロフィールを付けたいときに使う記述方法です。名前とふりがなは、変換後「名前（ふりがな）氏」という表示になります。また、画像の幅を600pxにすると、プロフィールと幅がそろいます。プロフィールの肩書きやプロフィールの行頭に、半角空白でインデントを入れることが必須です。
```
<<Fig_P>>
src: [画像ファイル名] ※例 1234_ichigo.jpg
width: [画像を表示するときの幅を指定] ※例 600px
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
……

{%background-color:#e6e6e6; %padding:1em;}
===div
　本文テキスト。もちろん図なども入れられます。

<<Fig_N>>
src: 1234_fig.png
width: 450px

==/div
```

#### ■画像回り込みの書き方

本文テキストの画像回り込み指定は、画像と回り込ませる本文テキストとを、`===wraparound`と`==/wraparound`で挟んでやることで行えます。

ただし、画像を右に置くか左に置くかの指定も必要です。画像の記述`<<Fig_●>>`の上に、画像を右に置く場合には`{:.imgR}`、左に置く場合には`{:.imgL}`と記述します。

次の例では、画像を右に置き、その周りに本文テキストを回り込ませます。

```
（本文）
……

===wraparound

{:.imgR}
<<Fig_N>>
src: 1234_fig.png
width: 200px

　回り込ませる本文テキスト〜
==/wraparound
```

また、画像の周りに本文テキストを回り込ませないようにする場合には、本文テキストの各段落の上に`{:.ovh}`という記述を加えます。

```
（本文）
……

===wraparound

{:.imgR}
<<Fig_N>>
src: 1234_fig.png
width: 200px

{:.ovh}
　回り込ませない本文テキスト（段落1）〜

{:.ovh}
　回り込ませない本文テキスト（段落2）〜
==/wraparound
```

#### ■脚注の書き方

次のように、本文テキスト中の脚注を付けたい言葉などに`[^1]`などとアンカーを付け、脚注を置きたい場所に`[^1]: 〜`という形で脚注本体を書きます。脚注本体のコロンを忘れなく。脚注番号には半角英数字が使えます（[^1]、[^imi01]など）。変換後は出現順に[1]、[2]という通し番号による表記に変わります。

```
　ほら、ここに難しい専門用語[^1]が1つ。ここにも意味の分からない専門用語[^2]がもう1つ。

　それからいろんな話がありつつ、この下に脚注を置きたいのなら、次のように記述します。

[^1]: 難しい専門用語の意味。もちろん[リンク](https://www.example.com)も置けますよ。

[^2]: 意味の分からない専門用語の意味。
```

なお、ZineBrewerでは、コラムに`footnotes`クラスを適用したスタイルで脚注本体を表示するようになっています。通常のコラムの形ではスカスカした見た目になってしまうので、追加CSSでスタイルを当てることをお勧めします。

#### ■定義表の書き方

定義リストの記述を`===dtable`〜`==/dtable`で挟むと、左に項目、右に内容のテーブル（表）ができます。キャプション（caption）を定義できるほか、1列目の幅を`th-width`属性で指定できます。

例えば、次のように記述すると、

```
{:caption="イベント概要" th-width="20%"}
===dtable
イベント名
:  HRzine Day 2020 Autumn

テーマ
:  ニューノーマルが来た！〜人事・労務がいま整えるべきこと〜

日時
:  2020年10月21日(水) 13:00～18:35

会場
:  オンライン
==/dtable
```

次のように表示されます。

![dtable](https://user-images.githubusercontent.com/24837059/133894991-59887c24-3c2f-402d-a854-b56c55d7da8c.png)

#### ■スタイルの書き方

最後に、スタイルの記述方法を説明します。

Kramdown（拡張Markdown）では、文字や段落にHTMLの属性を付けることができます。例えば、次のように記述すると、太字部分が赤色になり下線も引かれます。

```
ここは次の試験で**必ず出題する**{:style="color:red; text-decoration:underline;"}ところだから、しっかり勉強してきなさい。
```

これは、`**必ず出題する**{:style="color:red; text-decoration:underline;"}`という部分は、`<strong style="color:red; text-decoration:underline;">必ず出題する</strong>`と変換されるためです。

ZineBrewerでは、styleのところをもう少し簡潔に書けるようにしてあります。style属性中の指定**一つひとつ**を、パーセント記号とセミコロンで括ります。

```
ここは次の試験で**必ず出題する**{:%color:red; %text-decoration:underline;}ところだから、しっかり勉強してきなさい。
```

また、太字にしないで、ただ赤字・下線引きにしたい場合には、次のように記述します。

```
ここは次の試験で[[必ず出題する]]{:%color:red; %text-decoration:underline;}ところだから、しっかり勉強してきなさい。
```

段落に対してスタイルを当てる場合には、段落の直前あるいは直後にスタイルを記述します。例えば、次のように記述すると、段落の背景に薄い赤色に敷くことができます（余白も少しとっています）。

```
{:%background-color:#ffe6e6; %padding:15px;}
ここは次の試験で必ず出題するところだから、しっかり勉強してきなさい。
```

行頭の丸数字などを頭出し（ぶら下げ）したいことがあると思いますが、それは次のように記述します。

```
{:%padding-left:1em; %text-indent:-1em;}
①このように書いてやると、「①」の部分だけ左につきだし、以降の文章が引っ込んだ形で表示できます。
```

![Hanging Indent](https://user-images.githubusercontent.com/24837059/94996073-59f3e700-05dd-11eb-87f7-8a16be840f6f.png)

#### id属性、class属性、その他の属性

Kramdown（拡張Markdown）の`{: }`の中には、次のようにしてid属性とclass属性を記述できます。

```
{:#id_1234 .footnotes}
id属性は#、class属性は.を使って記述できます。
```

その他の属性はstyle以外、略記方法はありませんが、HTMLと同様に`{:rel="lightbox}"`とイコールを使った書き方にすれば、何でも指定できます。

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ZineBrewer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/akinori-ichigo/zine_brewer/blob/master/CODE_OF_CONDUCT.md).
