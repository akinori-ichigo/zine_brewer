# -*- coding: utf-8 -*-
#
#--
# Copyright (C) 2016 Akinori Ichigo <akinori.ichigo@gmail.com>
#
# This file is part of kramdown which is licensed under the MIT.
#++
#

module Kramdown
  module Parser
    class Kramdown

      SPAN_START = /(?:\[\[\s*?)/

      # Parse the span at the current location.
      def parse_span
        start_line_number = @src.current_line_number
        saved_pos = @src.save_pos

        result = @src.scan(SPAN_START)
        stop_re = /(?:\s*?\]\])/

         el = Element.new(:span, nil, nil, :location => start_line_number)
         found = parse_spans(el, stop_re) do
           el.children.size > 0
         end

        if found
          @src.scan(stop_re)
          @tree.children << el
        else
          @src.revert_pos(saved_pos)
          @src.pos += result.length
          add_text(result)
        end
      end
      define_parser(:span, SPAN_START, '\[\[')

    end
  end
end
