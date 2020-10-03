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

    $ zine_brewer [kramdown_document]

## Enhanced Notation in ZineBrewer

ここでは、Kramdown（拡張Markdown）に加えて記述可能にした、ZineBrewer向けの記法を説明します。

ZineBrewerで扱う原稿は「ヘッダー」と「本文」に分かれます。以下ではそれぞれ説明します。

### ヘッダー

ヘッダーは6つの項目からなります。各項目は空行を挟んで記述してください。以下の方法で記述を省略することもできます。

* `---`と書く
* 以下省略。例えば、コーナー名とタイトルだけ書いておき、以下は何も書かない（`---`も書かない）ということができます。ただし、以下省略でも、最後の`■記事ID■：0000`だけは書くことができます。

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

　もともと、Markdown原稿にCSSスタイルを書き込んでおく方法はないかと思い、見つけたのがKramdownです。文字単位・段落単位でidやclass、各種属性を記述しておくことができました。ただし、Kramdownが出力するHTMLは、翔泳社の記事配信システムが受け付けるHTMLフォーマットとは少し異なる部分があります。そこで、Kramdownを拡張し、翔泳社の記事配信システムが受け付けるHTMLを出力するようにしたツールが、ZineBrewerです。

1234_title.png

市古 明典

■記事ID■：1234

<%-- page -->

（以下、本文）
```

ヘッダーと本文の境界には、本文ページの起こしを指示する`<%-- page -->`を記述します。

ヘッダーの最後に記述する`■記事ID■：0000`は、原稿を入れているフォルダの名前を記事IDにしている場合を除き、記述するようにしてください。

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ZineBrewer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/akinori-ichigo/zine_brewer/blob/master/CODE_OF_CONDUCT.md).
