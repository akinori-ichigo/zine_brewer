require "mustache"
require "Kramdown"
require "htmlbeautifier"

require "darkmouun/version"
require "darkmouun/parser/extensions"
require "darkmouun/parser/span"
require "darkmouun/converter/span"

module Kramdown
  module Parser
    class Kramdown
      alias_method :super_initialize, :initialize
      def initialize(source, options)
        super_initialize(source, options)
        @span_parsers.insert(5, :span)
      end
    end
  end
end

module Darkmouun
  class << self
    def document
      Darkmouun
    end
  end

  class Darkmouun
    attr_accessor :pre_process, :post_process
  
    def initialize(source, options ={}, converter = :html)
      @source, @options = source, options
      @templates = {}
      begin
        @converter = case converter
        when String
          ('to_' + converter).intern
        when Symbol
          ('to_' + (converter.to_s)).intern
        else
          Exception.new "Invalid converter: Neither Symbol nor String"
        end
      rescue => e
        p e
      end
    end

    def add_templates(dir, *tmpls)
      # for Mustache
      tmpls.each do |tmpl|
        abs_path = dir + tmpl
        tmpl_module = Module.new
        tmpl_module.module_eval(File.read(abs_path), abs_path)
        tmpl_module.constants.each do |i|
          c = tmpl_module.const_get(i)
          if c.is_a?(Class) && c.superclass == Mustache
            @templates[i] = c
          end
        end
      end
    end

    def convert
      do_pre_process
      apply_mustache
      apply_kramdown
      do_post_process
      beautify
    end

    private

    def do_pre_process
      begin
        @pre_process.call(@source) unless @pre_process.nil?
      rescue => e
        raise e.class.new("\n#{e.message}\n\n>>> ERROR in \"Pre-process\" <<<\n")
      end
    end

    def apply_mustache
      begin
      @source = @source.gsub(/<<(.+?)>>\n((?:[# \-]*[\w_][\w\d_]*: *\n?(?: +.+\n)+)+)/) do |s|
        obj_spot_template, data = (@templates[$1.to_sym]).new, $2
        YAML.load_stream(data).compact.reduce(&:merge).each do |k, v|
          obj_spot_template.define_singleton_method(k){ v }
        end
        obj_spot_template.render + "\n"
      end
      rescue => e
        raise e.class.new("\n#{e.message}\n\n>>> ERROR in \"Mustache-process\" <<<\nMaybe, incorrect tags of the template exist.\n")
      end
    end

    def apply_kramdown
      begin
        @result = Kramdown::Document.new(@source, @options).send(@converter)
      rescue => e
        raise e.class.new("\n#{e.message}\n\n>>> ERROR in \"kramdown-process\" <<<\n")
      end
    end

    def do_post_process
      begin
        @post_process.call(@result) unless @post_process.nil?
      rescue => e
        raise e.class.new("\n#{e.message}\n\n>>> ERROR in \"Post-process\" <<<\n")
      end
    end

    def beautify
      HtmlBeautifier.beautify(@result)
    end
  
  end
end
