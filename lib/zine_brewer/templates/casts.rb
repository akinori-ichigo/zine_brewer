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
  # article#contents div.article div.casts>div ~ div { margin-top:8px; }

  @template = <<EOT
  <div class="casts" style="margin-bottom:30px; padding:13px 13px 3px; border:solid 2px #eee;">
  {{#prof_list}}
    {{#title_sw}}<h4>{{title}}</h4>{{/title_sw}}
    <div class="imgLRBlock cf">
      <figure class="imgL">
        <img src="{{fig_src}}" loading="lazy" alt="{{name}}" style="height:135px;" />
      </figure>
      <p class="ovh" markdown="span" style="font-size:14px; line-height:1.7; margin-bottom:10px;"><strong style="font-size:15px;">{{name}}（{{huri}}）氏</strong><br />{{& caption}}</p>
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
      l_cap.chomp.sub(/^\\/, '').gsub(/\n/, '(((BR)))')
    rescue
      nil
    end
  end

end

