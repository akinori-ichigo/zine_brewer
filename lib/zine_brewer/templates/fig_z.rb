# coding: utf-8

require 'mustache'

require_relative 'fig/module_fig_base'

class Fig_Z < Mustache

  include Fig_00

  # <<Fig_Z>>
  # src: 画像ファイル名
  # width: 画像幅
  # height: 画像高さ
  # cap: キャプション

  @template = <<EOT
<figure>
  {{#imgs_list}}
  <a href="{{fig_src}}" rel="lightbox" target="_blank"><img src="{{fig_src}}" alt="{{alt}}" {{& img_style}}/></a>
  {{/imgs_list}}
  <figcaption markdown="span">{{#caption}}{{& caption}}<br/>{{/caption}}［画像クリックで拡大表示］</figcaption>
</figure>
EOT

end

