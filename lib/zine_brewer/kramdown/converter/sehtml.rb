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

      def convert_img(el, indent)
        f = File.basename(el.attr['src'])
        if %r{^common} =~ File.dirname(el.attr['src'])
          el.attr['src'] = "/static/images/article/common/#{f}"
        else
          el.attr['src'] = "/static/images/article/■記事ID■/#{/^\d+_/ =~ f ? f : '■記事ID■_' + f}"
        end
        "<img#{html_attributes(el.attr)} />"
      end

      def convert_codeblock(el, indent)
        raw_caption = el.attr.delete('caption')
        caption = if raw_caption.nil?
          ''
        else
          el_caption = Document.new(raw_caption, {:auto_ids => false, :input => 'sekd'}).root.children[0]
          format_as_block_html('div', {'class' => 'caption'}, inner(el_caption, indent), indent + 2)
        end

        result = escape_html(el.value)
        result.chomp!
        if el.attr['class'].to_s =~ /\bshow-whitespaces\b/
          result.gsub!(/(?:(^[ \t]+)|([ \t]+$)|([ \t]+))/) do |m|
            suffix = ($1 ? '-l' : ($2 ? '-r' : ''))
            m.scan(/./).map do |c|
              case c
              when "\t" then "<span class=\"ws-tab#{suffix}\">\t</span>"
              when " " then "<span class=\"ws-space#{suffix}\">&#8901;</span>"
              end
            end.join('')
          end
        end

        format_as_indented_block_html('div', {'class' => 'src_frame'},
          caption + '  ' + format_as_indented_block_html('pre', {'class' => el.attr['class']}, result, indent),
          indent)
      end
      
      def convert_column(el, indent)
        format_as_indented_block_html('section', el.attr, inner(el, indent), indent)
      end
      
      # Makes caption element from caption attr of table element.
      def table_caption(raw_caption)
        el_caption = Document.new(raw_caption, {:auto_ids => false, :input => 'sekd'}).root.children[0]
        format_as_block_html('caption', {}, inner(el_caption, indent), indent)
      end

      def convert_table(el, indent)
        raw_caption = el.attr.delete('caption')
        table = super(el, indent)
        if !raw_caption.nil?
          table.sub!(/\A(<table.*?>)/, "\\1\n#{table_caption(raw_caption)}\n")
        end
        table.gsub(/^\s*<\/?t(head|body|foot)>\n/, '')
             .gsub(/ style="text-align: left"/, '')
             .gsub(/ style="text-align: center"/, ' class="txtC"')
             .gsub(/ style="text-align: right"/, ' class="txtR"')
      end

      def convert_definition_table(el, indent)
        th_width = el.attr.delete('th-width')
        th = th_width.nil? ? "<th>" : "<th width=\"#{th_width}\">"
        raw_caption = el.attr.delete('caption')
        rows = raw_caption.nil? ? '' : table_caption(raw_caption)
        inner(el.children.first, indent).scan(/(<dt>.+?<\/dt>|<dd>.+?<\/dd>)/m).
          map{|x| x.first.sub(/\A<dt>(.+)<\/dt>\z/m, "#{th}\\1</th>")}.
          map{|x| x.sub(/\A<dd>(.+)<\/dd>\z/m, "<td>\\1</td>")}.
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
        format_as_block_html('section', el.attr, "\n  <h4>注</h4>\n" + inner(el, indent), indent)
      end

      def convert_a(el, indent)
        res = inner(el, indent)
        attr = el.attr.dup
        if attr['href'].start_with?('mailto:')
          mail_addr = attr['href'][7..-1]
          attr['href'] = obfuscate('mailto') << ":" << obfuscate(mail_addr)
          res = obfuscate(res) if res == mail_addr
        else
          attr['target'] = '_blank' unless attr['href'].start_with?('#')
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
