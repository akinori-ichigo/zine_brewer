# coding: utf-8

class Casts < Mustache

  # <<Casts>>
  # casts:
  #   src:  写真ファイル名
  #   name: 姓 名
  #   huri: ふり がな
  #   cap:  プロフィール

  # CSSに下記の登録が必要
  # article#contents div.article div.casts>div ~ div { margin-top:8px; }

  @template = <<EOT
  <div class="casts" style="margin-bottom:30px; padding:13px 13px 3px; border:solid 2px #eee;">
  {{#prof_list}}
    <div class="imgLRBlock cf">
      <figure class="imgL">
        <img src="{{fig_src}}" alt="{{name}}" style="height:135px;" />
      </figure>
      <p class="ovh" markdown="span" style="font-size:14px; line-height:1.7; margin-bottom:10px;"><strong>{{name}}（{{huri}}）氏</strong><br />{{& caption}}</p>
    </div>
  {{/prof_list}}
  </div>
EOT

  def prof_list
    result = []
    (casts rescue a_cast_param).each do |h|
      a_cast = {}
      raise "Error: No src:" if h["src"].nil?
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
    [{"src" => (src rescue nil),
      "name" => (name rescue nil),
      "huri" => (huri rescue nil),
      "cap" => (cap rescue nil)}]
  end

  def make_src(l_src)
    case File.dirname(l_src)
    when ".", "images"
      "/static/images/article/■記事ID■/#{File.basename(l_src)}"
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

__END__

{:.casts %margin-bottom:45px; %padding:13px 13px 3px; %border:solid 2px #eee;}
===div

{:.imgLRBlock .cf}
===div
{:.imgL}
<<Fig_N>>
src: 2096_misonou_p.jpg
height: 135px

{:.ovh markdown="1" %font-size:14px; %line-height:1.7; %margin-bottom:10px;}
**御園生 銀平（みそのう ぎんぺい）氏**<br/>
ソフトバンク株式会社[[ ]]{:%font-size:3px;}人事本部[[ ]]{:%font-size:3px;}戦略企画統括部[[ ]]{:%font-size:3px;}人材戦略部[[ ]]{:%font-size:3px;}デジタルHR推進課。<br/>
（※御園生様のプロフィールを100〜150字程度でお願いいたします）。
==/div

{:.imgLRBlock .cf}
===div
{:.imgL}
<<Fig_N>>
src: 2096_shikauchi_p.jpg
height: 135px

{:.ovh markdown="1" %font-size:14px; %line-height:1.7; %margin-bottom:10px;}
**鹿内 学（しかうち まなぶ）氏**<br/>
博士（理学）。株式会社シンギュレイト 代表。<br/>
働く中でのコミュニケーション・データから関係性に注目した次世代ピープルアナリティクスにとりくむ。代表を務めるシンギュレイトでは1 on 1や会議で利用できる可視化ツールを提供中。働く組織の科学と実用をめざす。情報量規準が好き、サッカー好き、漫画好き。
==/div

==/div


