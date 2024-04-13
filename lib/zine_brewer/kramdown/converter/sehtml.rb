# -*- coding: utf-8 -*-
#
#--
# Copyright (C) 2009-2015 Thomas Leitner <t_leitner@gmx.at>
# Copyright (C) 2016 Akinori Ichigo <ichigo@shoeisha.co.jp>
# 
# This file is part of kramdown which is licensed under the MIT.
#++
#

require 'kramdown'
require 'kramdown/parser'
require 'kramdown/converter'
require 'kramdown/utils'

module Kramdown
  module Converter
    class SeHtml < Html

     def convert_standalone_image(el, indent)
        f = File.basename(el.children.first.attr['src'])
        if %r{^common} =~ File.dirname(el.children.first.attr['src'])
          el.children.first.attr['src'] = "/static/images/article/common/#{f}"
        else
          el.children.first.attr['src'] = "/static/images/article/■記事ID■/#{/^\d+_/ =~ f ? f : '■記事ID■_' + f}"
        end
        el.children.first.attr['loading'] = 'lazy'
        super(el, indent)
     end

      def convert_img(el, indent)
        f = File.basename(el.attr['src'])
        if %r{^common} =~ File.dirname(el.attr['src'])
          el.attr['src'] = "/static/images/article/common/#{f}"
        else
          el.attr['src'] = "/static/images/article/■記事ID■/#{/^\d+_/ =~ f ? f : '■記事ID■_' + f}"
        end
        el.attr['loading'] = 'lazy'
        "<img#{html_attributes(el.attr)} />"
      end

      def convert_codeblock(el, indent)
        format_as_indented_block_html('div', el.attr, inner(el, indent), indent)
      end

      def convert_pre(el, indent)
        format_as_block_html('pre', el.attr, el.value, indent)
      end
      
      def convert_column(el, indent)
        format_as_indented_block_html('div', el.attr, inner(el, indent), indent)
      end
      
      # Makes caption element from caption attr of table element.
      def table_caption(raw_caption)
        el_caption = Document.new(raw_caption, {:auto_ids => false, :input => 'sekd'}).root.children[0]
        format_as_block_html('caption', {}, inner(el_caption, indent), indent)
      end

      def convert_table(el, indent)
        raw_caption = el.attr.delete('caption')
        table = super(el, indent)
        if raw_caption.nil?
          table
        else
          table.sub!(/\A(<table.*?>)/, "\\1\n#{table_caption(raw_caption)}\n")
        end
      end

      def convert_definition_table(el, indent)
        th_width = el.attr.delete('th-width')
        th = th_width.nil? ? "" : " width=\"#{th_width}\""
        raw_caption = el.attr.delete('caption')
        rows = raw_caption.nil? ? '' : table_caption(raw_caption)
        inner(el.children.first, indent).scan(/(<dt.*?>.+?<\/dt>|<dd.*?>.+?<\/dd>)/m).
          map{|x| x.first.sub(/\A<dt(.*?)>(.+)<\/dt>\z/m, "<th#{th}\\1>\\2</th>")}.
          map{|x| x.sub(/\A<dd(.*?)>(.+)<\/dd>\z/m, "<td\\1>\\2</td>")}.
          each_slice(2) do |x|
            row = x.map{|c| ('  '*(indent + 2)) + c}.join("\n")
            rows += format_as_indented_block_html('tr', {}, "#{row}\n", indent + 2)
          end
        format_as_indented_block_html('table', el.attr, rows, indent)
      end

      def convert_dt(el, indent)
        result = super
        result.sub(/<dt>\\/, '<dt>')
      end

      def convert_kakokiji(el, indent)
        "<kakokiji>#{el.value.strip}</kakokiji>\n\n"
      end

      def convert_div(el, indent)
        format_as_indented_block_html('div', el.attr, inner(el, indent), indent)
      end

      def convert_page(el, indent)
        el.value + "\n"
      end

      def convert_footnote_marker_sekd(el, indent)
        %!<sup id="fnref:#{el.value}"><a href="#fn:#{el.value}">[#{el.value}]</a></sup>!
      end

      def convert_footnote_definition_sekd(el, indent)
        format_as_block_html('div', el.attr, "\n  <h4>注</h4>\n" + inner(el, indent), indent)
      end

      def convert_a(el, indent)
        res = inner(el, indent)
        attr = el.attr.dup
        if attr['href'].start_with?('mailto:')
          mail_addr = attr['href'][7..-1]
          attr['href'] = obfuscate('mailto') << ":" << obfuscate(mail_addr)
          res = obfuscate(res) if res == mail_addr
        else
          attr['target'] = '_blank' if (attr['target'].nil? && !attr['href'].start_with?('#'))
        end
        format_as_span_html(el.type, attr, res)
      end

      def convert_em(el, indent)
        format_as_span_html('strong', el.attr, inner(el, indent))
      end
      
      def convert_math(el, indent)
        if (result = format_math(el, :indent => indent))
          result
        elsif el.options[:category] == :block
          format_as_block_html('pre', el.attr, "$$\n#{el.value}\n$$", indent)
        else
          format_as_span_html('math', el.attr, "$#{el.value}$")
        end
      end
      
      def convert_root(el, indent)
        result = inner(el, indent)
        if @toc_code
          toc_tree = generate_toc_tree(@toc, @toc_code[0], @toc_code[1] || {})
          text = if toc_tree.children.size > 0
                   convert(toc_tree, 0)
                 else
                   ''
                 end
          result.sub!(/#{@toc_code.last}/, text.gsub(/\\/, "\\\\\\\\"))
        end
        result
      end
    end
  end
end
