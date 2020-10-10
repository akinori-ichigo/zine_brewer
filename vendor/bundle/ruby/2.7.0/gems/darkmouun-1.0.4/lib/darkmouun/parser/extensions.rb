# -*- coding: utf-8 -*-
#
#--
# Copyright (C) 2017 Akinori Ichigo <akinori.ichigo@gmail.com>
#
# This file is part of kramdown which is licensed under the MIT.
#++
#

require 'kramdown'

module Kramdown
  module Parser
    class Kramdown

      # Parse the string +str+ and extract all attributes and add all found attributes to the hash
      # +opts+.
      def parse_attribute_list(str, opts)
        return if str.strip.empty? || str.strip == ':'
        style_attr = []
        attrs = str.scan(ALD_TYPE_ANY)
        attrs.each do |key, sep, val, style_key, style_val, ref, id_and_or_class, _, _|
          if ref
            (opts[:refs] ||= []) << ref
          elsif id_and_or_class
            id_and_or_class.scan(ALD_TYPE_ID_OR_CLASS).each do |id_attr, class_attr|
              if class_attr
                opts[IAL_CLASS_ATTR] = (opts[IAL_CLASS_ATTR] || '') << " #{class_attr}"
                opts[IAL_CLASS_ATTR].lstrip!
              else
                opts['id'] = id_attr
              end
            end
          elsif style_key
            style_attr << (style_key + style_val)
          else
            val.gsub!(/\\(\}|#{sep})/, "\\1")
            if /\Astyle\Z/i =~ key
              style_attr << val
            else
              opts[key] = val
            end
          end
        end
        (opts['style'] = style_attr.join(' ')) unless style_attr.empty?
        warning("No or invalid attributes found in IAL/ALD content: #{str}") if attrs.length == 0
      end

      ALD_TYPE_STYLE_ATTR = /%(#{ALD_ID_NAME}:)\s*?((?:\\\}|\\;|[^\};])*?;)/
      remove_const(:ALD_TYPE_ANY)
      ALD_TYPE_ANY = /(?:\A|\s)(?:#{ALD_TYPE_KEY_VALUE_PAIR}|#{ALD_TYPE_STYLE_ATTR}|#{ALD_TYPE_REF}|#{ALD_TYPE_ID_OR_CLASS_MULTI})(?=\s|\Z)/

    end
  end
end
