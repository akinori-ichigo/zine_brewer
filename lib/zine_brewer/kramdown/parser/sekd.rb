# -*- coding: utf-8 -*-
#
# Copyright (C) 2017 Akinori Ichigo <akinori.ichigo@gmail.com>
#
# This source code has written to extend and modify kramdown for
# web media published by SHOEISHA Co., Ltd.
#

require 'kramdown'
require 'kramdown/parser'

module Kramdown
  module Parser
    class Sekd < Kramdown

      def initialize(source, options)
        super

        parsers_replacing = {
          :@block_parsers => {:codeblock_fenced => :codeblock_fenced_sekd,
                              :footnote_definition => :footnote_definition_sekd},
          :@span_parsers  => {:footnote_marker => :footnote_marker_sekd}
        }
        parsers_replacing.each do |target, definitions|
          target_instance = instance_variable_get(target)
            definitions.each do |current, replacement|
            target_instance[target_instance.index(current)] = replacement
          end
        end

        @block_parsers.insert(5, :column, :definition_table, :wraparound, :lineup, :div, :page)

        @page = 0
        @fn_counter = 0
        @fn_number = Hash.new{|h, k| h[k] = (@fn_counter += 1).to_s }
      end

      LIST_START_OL = /^(#{OPT_SPACE}(?:[^\\]|)\d+\.)(#{PATTERN_TAIL})/

      # Parse the fenced codeblock at the current location
      # code highlighting by Google Prettify.
      def parse_codeblock_fenced_sekd
        if @src.check(self.class::FENCED_CODEBLOCK_MATCH)
          start_line_number = @src.current_line_number
          @src.pos += @src.matched_size
          el = new_block_el(:codeblock, @src[4].chomp, nil, :location => start_line_number)
          lang, linenums = @src[3].to_s.strip.split(/:/)
          lang_ext = LANG_BY_EXT[lang] || lang
          el.attr['class'] = "prettyprint" + (lang_ext.nil? ? ' nocode' : " lang-#{lang_ext}")
          el.attr['class'] += " linenums:#{linenums}" unless linenums.nil?
          @tree.children << el
          true
        else
          false
        end
      end
      FENCED_CODEBLOCK_MATCH = /^(([~`]){3,})\s*?(\w[\d:\w-]*)?\s*?\n(.*?)^\1\2*\s*?\n/m
      define_parser(:codeblock_fenced_sekd, /^[~`]{3,}/, nil, 'parse_codeblock_fenced_sekd')

      LANG_BY_EXT = {
        "bash"=>"bsh", "clojure"=>"clj", "csharp"=>"cs", "c#"=>"cs", "el"=>"lisp",
        "erl"=>"erlang", "golang"=>"go", "haskell"=>"hs", "javascript"=>"js", "obj-c"=>"m",
        "objective-c"=>"m", "objc"=>"m", "pas"=>"pascal", "python"=>"py", "rlang"=>"r",
        "ruby"=>"rb", "sc"=>"scala", "visualbasic"=>"vb"
      }.merge(Hash[*%w!
        apollo basic bsh c cc cpp clj cs csh css cyc cv dart erlang go hs htm html java js
        llvm m matlab ml mumps mxml lisp lua n pascal perl pl pm proto py r rb rd scala sh
        sql tcl tex vb vhdl wiki xhtml xml xq xsl yaml yml
      !.map{|i| [i, i]}.flatten])
    
      def parse_div
        set_block("DIV_MATCH", :div)
      end

      DIV_MATCH = /^={3,}\s*?div\s*?\n(.*?)^={2,}\/div\s*?\n/mi
      define_parser(:div, /^={3,}div/i, nil, 'parse_div')

      def parse_wraparound
        if @src.check(self.class::WRAPAROUND_MATCH)
          start_line_number = @src.current_line_number
          @src.pos += @src.matched_size
          attributes = {'class' => "wraparound0 text-center mb-3 mb-md-2 d-md-flex flex-column col-md-#{@src[2]} " + case @src[1]
          when /left/i
            'float-md-start me-md-3'
          when /right/i
            'float-md-end ms-md-3'
          end}
          el = Element.new(:div, nil, attributes, :location => start_line_number)
          parse_blocks(el, @src[3])
          update_attr_with_ial(el.attr, @block_ial) unless @block_ial.nil?
          @tree.children << el
          true
        else
          false
        end
      end

      WRAPAROUND_MATCH = /^={3,}\s*?wraparound\(\s*(right|left)\s*,\s*([1-9]|10|11|12)\s*\)\s*?\n(.*?)^={2,}\/wraparound\s*?\n/mi
      define_parser(:wraparound, /^={3,}wrap/i, nil, 'parse_wraparound')

      def parse_lineup
        if @src.check(self.class::LINEUP_MATCH)
          start_line_number = @src.current_line_number
          @src.pos += @src.matched_size
          el = Element.new(:div, nil,
                           {'class' => "lineup0 text-center mb-3 mb-md-2 d-md-flex flex-row"},
                           :location => start_line_number)
          parse_blocks(el, @src[1])
          el.children.filter{|i| i.type == :html_element && i.value == "figure"}[0..-2].each do |fig|
            fig.attr.update({'class' => 'me-md-2'})
          end
          update_attr_with_ial(el.attr, @block_ial) unless @block_ial.nil?
          @tree.children << el
          true
        else
          false
        end
      end

      LINEUP_MATCH = /^={3,}\s*?lineup\s*?\n(.*?)^={2,}\/lineup\s*?\n/mi
      define_parser(:lineup, /^={3,}line/i, nil, 'parse_lineup')

      def parse_column
        set_block("COLUMN_MATCH", :column, {'class' => 'columnSection'})
      end

      COLUMN_MATCH = /^={3,}\s*?column\s*?\n(.*?)^={2,}\/column\s*?\n/mi
      define_parser(:column, /^={3,}co/i, nil, 'parse_column')

      def parse_definition_table
        set_block("DEFINITION_TABLE_MATCH", :definition_table)
      end

      DEFINITION_TABLE_MATCH = /^={3,}\s*?dtable\s*?\n\n*(.*?)^={2,}\/dtable\s*?\n/mi
      define_parser(:definition_table, /^={3,}dt/i, nil, 'parse_definition_table')

      @page = 0
      def parse_page
        if @src.check(self.class::PAGE_MATCH)
          start_line_number = @src.current_line_number
          @src.pos += @src.matched_size
          page = (@page > 0 ? "</div>\n<!-- page_delimiter -->\n" : '') + "<div id=\"p#{@page+=1}\">"
          @tree.children << new_block_el(:page, page, nil, :location => start_line_number)
          true
        else
          false
        end
      end

      PAGE_MATCH = /^<%-*\s*page\s*-*>/
      define_parser(:page, /^<%/, nil, 'parse_page')

      def parse_footnote_definition_sekd
        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size
        if @fn_number.has_key?(@src[1])
          warning("Duplicate footnote name '#{@src[1]}' on line #{start_line_number} - overwriting")
        end
        a = %!<a href="#fnref:#{@fn_number[@src[1]]}">\\[#{@fn_number[@src[1]]}\\]</a>: #{@src[2].strip}!
        p = new_block_el(:p, nil, {'id' => "fn:#{@fn_number[@src[1]]}"})
        p.children << new_block_el(:raw_text, a, nil)
        if @tree.children.last.type == :footnote_definition_sekd
          @tree.children.last.children << p
        elsif [-1, -2].map{|i| @tree.children[i].type } == [:blank, :footnote_definition_sekd]
          @tree.children.pop
          @tree.children.last.children << p
        else
          f = new_block_el(:footnote_definition_sekd, nil, {'class' => 'columnSection footnotes'},
                           :location => start_line_number)
          f.children << p
          @tree.children << f
        end
        true
      end

      FOOTNOTE_DEFINITION_START = /^#{OPT_SPACE}\[\^(#{ALD_ID_NAME})\]:\s*?(.*?\n#{CODEBLOCK_MATCH})/
      define_parser(:footnote_definition_sekd, FOOTNOTE_DEFINITION_START, /^#{OPT_SPACE}\[^/, 'parse_footnote_definition_sekd')

      def parse_footnote_marker_sekd
        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size
        unless @fn_number.has_key?(@src[1])
          warning("No footnote marker '#{@src[1]}' on line #{start_line_number} - missing")
        end
        @tree.children << new_block_el(:footnote_marker_sekd, @fn_number[@src[1]], nil,
                                       :location => start_line_number)
      end

      FOOTNOTE_MARKER_START = /\[\^(#{ALD_ID_NAME})\]/
      define_parser(:footnote_marker_sekd, FOOTNOTE_MARKER_START, '\[', 'parse_footnote_marker_sekd')

      private

      def set_block(match_regexp_name, element, attributes = nil)
        if @src.check(self.class.const_get(match_regexp_name))
          start_line_number = @src.current_line_number
          @src.pos += @src.matched_size
          el = Element.new(element, nil, attributes, :location => start_line_number)
          parse_blocks(el, @src[1])
          update_attr_with_ial(el.attr, @block_ial) unless @block_ial.nil?
          @tree.children << el
          true
        else
          false
        end
      end
    end
  end
end
