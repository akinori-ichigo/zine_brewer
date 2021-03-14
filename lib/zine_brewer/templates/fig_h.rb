# coding: utf-8

require 'mustache'

require_relative 'fig/module_fig_base'
require_relative 'fig/module_fig_plus'

class Fig_H < Mustache

  include Fig_00, Fig_01

  # <<Fig_H>>
  # src: 画像ファイル名
  # href: 画像クリックで遷移するURL
  # width: 画像幅
  # height: 画像高さ
  # cap: キャプション

  @template = <<EOT
<figure>
  {{#imgs_list}}
  {{#href}}<a href="{{href}}" target="_blank">{{/href}}<img src="{{fig_src}}" alt="{{alt}}" {{& img_style}}/>{{#href}}</a>{{/href}}
  {{/imgs_list}}
  {{#figcaption_sw}}<figcaption markdown="span">{{& caption}}</figcaption>{{/figcaption_sw}}
</figure>
EOT

end

