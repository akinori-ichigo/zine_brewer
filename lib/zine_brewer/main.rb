# coding: utf-8

require 'kconv'
require 'darkmouun'

require_relative 'kramdown/parser/sekd'
require_relative 'kramdown/converter/sehtml'

module ZineBrewer

  class Application

    attr_reader :corner, :title, :lead, :pic, :author, :css, :converted

    def initialize(path)

      begin
        Encoding.default_external =  Kconv.guess(File.open(path, 'r:BINARY').read)
        input_data = File.open(path, 'rt').read.encode('UTF-8')
      rescue
        raise 'ERROR: The input file does not exist. Check it.'
      end

      @dir = File.dirname(path)

      header, body = /\A((?:.|\n)*?)<%-- page -->/.match(input_data).yield_self do |m|
        if m.nil?
          ['', "\n\n" + input_data]
        else
          [m[1], '<%-- page -->' + "\n\n" + m.post_match]
        end
      end

      @article_id = if header.sub!(/^■記事ID■[^0-9]+(\d+)$/, '')
                      Regexp.last_match[1]
                    else
                      /^\d+/.match(File.basename(@dir)).yield_self{|m| m.nil? ? '■記事ID■' : m[0]}
                    end
      h = header.strip.split(/\n\n+/)
      @corner, @title, @lead, @author = [0, 1, 2, 4].map{|i| set_header_item(h[i], '')}
      @pic = set_header_item(h[3], ''){ /^\./ =~ h[3] ? h[3] : "/images/#{@article_id}_#{h[3]}" }
      @css = set_header_item(h[5], ''){ h[5].each_line.map do |i|
        if /^[@{}]/ =~ i
          i
        else
          /(\s*)(.+)/.match(i)[1..2].insert(1, '.c-article_content ').join + "\n"
        end
      end.join }

      @pp_header = make_pp_header
      @converted = convert(body)
    end

    def set_header_item(value, alt)
      if /\A\ufeff?[\-%]+\Z/ =~ value || value.nil?
        alt.define_singleton_method(:is_complete?){ false }
        alt
      else
        value = yield if block_given?
        value.define_singleton_method(:is_complete?){ true }
        value
      end
    end

    def make_pp_header
      header_output = []
      header_output << "［コーナー］\n#{@corner}" if @corner.is_complete?
      header_output << "［タイトル］\n#{@title}" if @title.is_complete?
      header_output << "［リード］\n<p>#{@lead}</p>" if @lead.is_complete?
      header_output << "［タイトル画像］\n#{File.basename(@pic)}" if @pic.is_complete?
      header_output << "［著者クレジット］\n#{@author}" if @author.is_complete?
      header_output << "［追加CSS］\n#{@css}" if @css.is_complete?
      header_output.join("\n\n")
    end

    ## Writing out header and body to each file
    def write_out
      make_proof_directory
      write_proof_header
      write_proof_body
    end

    def make_proof_directory
      @proof_dir = @dir + '/proof'
      begin
        Dir.mkdir(@proof_dir)
      rescue Errno::EEXIST
      end
    end

    def write_proof_header
      File.open("#{@proof_dir}/header.txt", 'wb') do |f|
        f.write(@pp_header)
      end
    end

    def write_proof_body
      File.open("#{@proof_dir}/body.txt", 'wb') do |f|
        f.write(@converted.gsub("<!-- page_delimiter -->\n", ''))
      end
    end

    ## Converts markdown to html and returns body
    def convert(body)
      dkmn = Darkmouun.document.new(body, {:auto_ids => false, :input => 'sekd'}, :se_html)

      ### Sets templates
      dkmn.add_templates "#{__dir__}/templates/", *Dir['*.rb',base:"#{__dir__}/templates/"]

      ### Sets pre process
      dkmn.pre_process = lambda do |t|
      end

      ### Sets post process
      dkmn.post_process = lambda do |t|
        t.gsub!('(((BR)))', '<br/>')
        t.gsub!(/■記事ID■/, @article_id)
        t.gsub!(/—/, "―")
        t.gsub!(/[‘’]/, "'")
        t.gsub!(/<li>\\/, '<li>')
        t << "</div>" if /<div id="p1">/ =~ t
      end

      ### Converts a markdown document and returns that converted body
      dkmn.convert
    end

    ### pretty print of the converted document
    def pretty_print
      @pp_header + "\n\n" + @converted
    end
  end
end

