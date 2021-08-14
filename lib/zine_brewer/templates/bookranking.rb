# coding: utf-8

require 'mustache'

class BookRanking < Mustache

  # <<BookRanking>>
  # url: AmazonのURL
  # title: 書名
  # src: 書影ファイル名
  # desc: 説明

  @template = <<EOT
  <div class="imgLRBlock cf">
    <figure class="imgR">
      <a href="{{url}}" target="_blank"><img alt="{{title}}" loading="lazy" src="{{cover}}" style="border:1px solid #808080;" width="100" title="{{title}}" /></a></figure>
    <p markdown="1">　{{& description}}</p>
  </div>
EOT

  def description
    Mustache.new.render(desc, {book: "『[#{title}](#{url})』"})
  end

  def cover
    case File.dirname(src)
    when ".", "images"
      f = File.basename(src)
      "/static/images/article/■記事ID■/#{/^\d+_/ =~ f ? f : '■記事ID■_' + f}"
    when "common"
      "/static/images/article/common/#{File.basename(src)}"
    else
      src
    end
  end

end

