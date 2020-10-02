# coding: utf-8

require_relative 'fig/module_fig_base'

class Fig_P < Mustache

  include Fig_00

  # <<Fig_P>>
  # src: 画像ファイル名
  # name: 姓 名
  # huri: ふり・がな
  # width: 画像幅
  # height: 画像高さ
  # cap: |
  #  キャプション

  @template = <<EOT
<figure>
  {{#imgs_list}}
  <img src="{{fig_src}}" alt="{{name}}氏" {{& img_style}} />
  {{/imgs_list}}
  <div style="text-align:left; padding:0em 2em;">
    <figcaption><strong>{{name}}（{{huri}}）氏</strong></figcaption>
    <figcaption markdown="span">{{caption}}</figcaption>
  </div>
</figure>
EOT

end

