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
      <a href="{{url}}" target="_blank"><img alt="{{title}}" src="{{cover}}" style="border:1px solid #808080; width:100px;" title="{{title}}" /></a></figure>
    <p markdown="1">　{{& description}}</p>
  </div>
EOT

  def description
    Mustache.new.render(desc, {book: "『[#{title}](#{url})』"})
  end

  def cover
    case File.dirname(src)
    when ".", "images"
      "/static/images/article/■記事ID■/#{File.basename(src)}"
    when "common"
      "/static/images/article/common/#{File.basename(src)}"
    else
      src
    end
  end

end

