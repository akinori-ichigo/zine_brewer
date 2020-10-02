# coding: utf-8

require_relative 'fig/module_fig_base'
require_relative 'fig/module_fig_plus'

class Fig_N < Mustache

  include Fig_00, Fig_01

  # <<Fig_N>>
  # src: 画像ファイル名
  # width: 画像幅
  # height: 画像高さ
  # cap: キャプション
  # from: 出典 << 出典URL

  @template = <<EOT
<figure>
  {{#imgs_list}}
  <img src="{{fig_src}}" alt="{{alt}}" {{& img_style}}/>
  {{/imgs_list}}
  {{#figcaption_sw}}<figcaption markdown="span">{{caption}}{{& cited_from}}</figcaption>{{/figcaption_sw}}
</figure>
EOT

end

