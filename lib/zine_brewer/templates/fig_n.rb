# coding: utf-8

require 'mustache'

require_relative 'fig/module_fig_base'

class Fig_N < Mustache

  include Fig_00

  # <<Fig_N>>
  # src: 画像ファイル名
  # width: 画像幅
  # height: 画像高さ
  # cap: キャプション

  @template = <<EOT
<figure>
  {{#imgs_list}}
  <img src="{{fig_src}}" loading="lazy" alt="{{alt}}" {{& img_style}} />
  {{/imgs_list}}
  {{#caption}}<figcaption markdown="span">{{& caption}}</figcaption>{{/caption}}
</figure>
EOT

end

