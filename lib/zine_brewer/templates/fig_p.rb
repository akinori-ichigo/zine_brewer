# coding: utf-8

require 'mustache'

require_relative 'fig/module_fig_base'

class Fig_P < Mustache

  include Fig_00

  # <<Fig_P>>
  # src: 画像ファイル名
  # width: 画像幅
  # height: 画像高さ
  # name: 姓 名
  # huri: ふり・がな
  # title: 肩書き
  # cap: |
  #      プロフィール

  @template = <<EOT
<figure>
  {{#imgs_list}}
  <img src="{{fig_src}}" loading="lazy" alt="{{name}}氏" {{& img_style}} />
  {{/imgs_list}}
  <figcaption style="text-align:left;">
    <strong>{{name}}（{{huri}}）氏</strong><br/>
    <span markdown="span">{{title}}</span>
    <div markdown="span" style="margin-top:6px;">
      {{& caption}}
    </div>
  </figcaption>
</figure>
EOT

end

