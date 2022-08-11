# coding: utf-8

require 'mustache'

class Book_Column < Mustache

  # <<Book_Column>>
  # title:  書名
  # src:    書影ファイル名
  # width:  書影幅
  # height: 書影高さ
  # alt:    書影のalt
  # btns:
  #   ボタン名1: URL1
  #   ...
  #   ボタン名n: URLn
  # indt:   スペック桁揃えのインデント数
  # spec:
  #   項目名1: データ1
  #   ...
  #   項目名n: データn
  # desc:    本の説明

  # ※使用条件：any-bulletクラスが定義済みであること

  @template = <<EOT
<section class="columnSection">
  <div class="d-md-flex">
    <figure class="me-md-3 text-center mb-3 mb-md-0 flex-shrink-0">
      <a href="{{url_amazon}}" target="_blank"><img alt="{{b_alt}}" src="{{b_cover}}" style="border:1px solid #808080;{{b_size}}" title="{{b_alt}}" /></a></figure>
    <div class="flex-grow-1">
      <p>
        {{#list_btns}}
        <a class="btn btn-danger" href="{{btn_url}}" style="color:white;" target="_blank">{{btn_name}}</a>
        {{/list_btns}}
      </p>
      <h5 class="mb-2">{{& b_title}}</h5>
      <ul class="mt-0 mb-0 ps-0 any-bullet" style="font-size:small; --w:{{b_indent}};">
        {{#list_specs}}
        <li class="mb-1">
          <span class="b" style="font-weight:bold;">{{spec_name}}</span>{{spec_data}}
        </li>
        {{/list_specs}}
      </ul>
      {{& b_desc}}
    </div>
  </div>
</section>
EOT

  def b_title
    begin
      title.chomp.gsub(/\n/, '<br/>')
    rescue
      '本のタイトル'
    end
  end
  
  def b_alt
    begin
      alt
    rescue
      begin
        title.chomp.gsub(/\n/, ' ')
      rescue
        '本のタイトル'
      end
    end
  end
  
  def b_cover
    begin
      case File.dirname(src)
      when ".", "images"
        f = File.basename(src)
        "/static/images/article/■記事ID■/#{/^\d+_/ =~ f ? f : '■記事ID■_' + f}"
      when "common"
        "/static/images/article/common/#{File.basename(src)}"
      else
        src
      end
    rescue
      '/static/images/article/common/book_cover_dummy.png'
    end
  end
  
  def b_size
    begin
      s = []
      s << " width:#{width};" rescue ''
      s << " height:#{height};" rescue ''
      s.join
    end
  end
  
  def url_amazon
    btns['Amazon'] rescue '#'
  end
  
  def list_btns
    begin
      result = []
      btns.each do |k, v|
        result << {'btn_name' => k, 'btn_url' => v}
      end
      result
    rescue
      [{'btn_name' => 'NO BUTTONS', 'btn_url' => '#'}]
    end
  end
  
  def b_indent
    indt rescue '4em'
  end
  
  def list_specs
    begin
      result = []
      specs.each do |k, v|
        result << {'spec_name' => k, 'spec_data' => v}
      end
      result
    rescue
      [{'spec_name' => 'NO SPECS', 'spec_data' => '...'}]
    end
  end
  
  def b_desc
    %Q{<p markdown="1" class="mt-3" style="font-size:small;">\n  #{desc.chomp.gsub(/\n/, '<br/>')}\n</p>} rescue ''
  end

end

