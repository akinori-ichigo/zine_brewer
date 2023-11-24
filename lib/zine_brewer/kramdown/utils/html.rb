# -*- coding: utf-8 -*-
#
#--
# Copyright (C) 2009-2015 Thomas Leitner <t_leitner@gmx.at>
# Copyright (C) 2016 Akinori Ichigo <ichigo@shoeisha.co.jp>
# 
# This file is part of kramdown which is licensed under the MIT.
#++
#
#

module Kramdown
  module Utils
    module Html

      def html_attributes(attr)
        return '' if attr.empty?

        attr.map do |k, v|
          if v.nil? || (k == 'id' && v.strip.empty?)
            ''
          elsif k == 'href'
            " #{k}=\"#{v.to_s}\""
          else
            " #{k}=\"#{escape_html(v.to_s, :attribute)}\""
          end
        end.join('')
      end

    end
  end
end

