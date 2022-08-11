# coding: utf-8

require 'mustache'

require_relative 'fig/module_fig_base'

class Fig_A < Mustache

  include Fig_00

  # <<Fig_A>>
  # src: 画像ファイル名
  # alt: altテキスト
  # width: 画像幅
  # height: 画像高さ
  # cap: キャプション

  @template = <<EOT
<figure{{& wraparound}}>
  {{#imgs_list}}
  <a href="{{fig_src}}" target="_blank"><img src="{{fig_src}}" loading="lazy" alt="{{alt}}" {{& img_style}} /></a>
  {{/imgs_list}}
  <figcaption markdown="span">{{#caption}}{{& caption}}<br/>{{/caption}}［画像クリックで拡大表示］</figcaption>
</figure>
EOT

end

