# coding: utf-8

require 'mustache'

class Casts < Mustache

  # <<Casts>>
  # casts:
  #   title: 見出し
  #   src:   写真ファイル名
  #   name:  姓 名
  #   huri:  ふり がな
  #   cap:   プロフィール

  # CSSに下記の登録が必要
  # .c-article_content div.casts { border: solid 2px #e5e5e5; }
  # .c-article_content div.casts h4 { border-bottom: 2px solid #e5e5e5; font-size: 1.8rem; }
  # .c-article_content div.casts p { font-size: 1.4rem; line-height: 1.7; }
  # .c-article_content div.casts p strong.name { font-size: 1.5rem; }
  # .c-article_content div.casts div.cast + div.cast { margin-top: 2rem; }
  # .c-article_content div.casts div.cast + h4 { margin-top: 1rem; }

  @template = <<EOT
  <div class="casts mb-5 pt-2 pb-2 px-3">
  {{#prof_list}}
    {{#title_sw}}<h4 class="mb-2">{{title}}</h4>{{/title_sw}}
    <div class="cast d-md-flex">
      <figure class="me-md-3 mb-2 mb-md-0 flex-shrink-0">
        <img src="{{fig_src}}" loading="lazy" alt="{{name}}" style="width:110px;" />
      </figure>
      <p markdown="span"><strong class="name">{{name}}（{{huri}}）氏</strong><br />{{& caption}}</p>
    </div>
  {{/prof_list}}
  </div>
EOT

  def prof_list
    result = []
    (casts rescue a_cast_param).each do |h|
      a_cast = {}
      raise "Error: No src:" if h["src"].nil?
      a_cast[:title] = h["title"]
      a_cast[:title_sw] = !h["title"].nil?
      a_cast[:fig_src] = make_src(h["src"])
      a_cast[:name] = h["name"]
      a_cast[:huri] = h["huri"]
      a_cast[:caption] = make_caption(h["cap"])
      result << a_cast
    end
    result
  end

  private
  def a_cast_param
    [{"title" => (title rescue nil),
      "src" => (src rescue nil),
      "name" => (name rescue nil),
      "huri" => (huri rescue nil),
      "cap" => (cap rescue nil)}]
  end

  def make_src(l_src)
    case File.dirname(l_src)
    when ".", "images"
      f = File.basename(l_src)
      "/static/images/article/■記事ID■/#{/^\d+_/ =~ f ? f : '■記事ID■_' + f}"
    when "common"
      "/static/images/article/common/#{File.basename(l_src)}"
    else
      l_src
    end
  end
  
  def make_caption(l_cap)
    begin
      l_cap.chomp.sub(/^\\/, '').gsub(/\n/, '<br/>')
    rescue
      nil
    end
  end

end

