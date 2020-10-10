# -*- coding: utf-8 -*-
#
#--
# copyright (c) 2017 akinori ichigo <akinori.ichigo@gmail.com>

require 'kramdown/parser'
require 'kramdown/converter'
require 'kramdown/utils'

module Kramdown
  module Converter
    class Html
      def convert_span(el, indent)
        format_as_span_html('span', el.attr, inner(el, indent))
      end
    end
  end
end

