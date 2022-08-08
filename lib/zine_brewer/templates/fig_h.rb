# coding: utf-8

require 'mustache'

require_relative 'fig/module_fig_base'

class Fig_H < Mustache

  include Fig_00

  # <<Fig_H>>
  # src: 画像ファイル名
  # href: 画像クリックで遷移するURL
  # width: 画像幅
  # height: 画像高さ
  # cap: キャプション

  @template = <<EOT
<figure{{& wraparound}}>
  {{#imgs_list}}
  <a href="{{href}}" target="_blank"><img src="{{fig_src}}" loading="lazy" alt="{{alt}}" {{& img_style}} /></a>
  {{/imgs_list}}
  {{#caption}}<figcaption markdown="span">{{& caption}}</figcaption>{{/caption}}
</figure>
EOT

end

