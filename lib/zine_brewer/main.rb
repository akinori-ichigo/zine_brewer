# coding: utf-8

require 'kconv'
require 'darkmouun'

require_relative 'kramdown/parser/sekd'
require_relative 'kramdown/converter/sehtml'

module ZineBrewer

  class Application

    Commons = "[hlink]: common/hlink.svg"

    attr_reader :corner, :title, :lead, :pic, :author, :css, :converted

    def initialize(path)

      begin
        Encoding.default_external =  Kconv.guess(File.open(path, 'r:BINARY').read)
        input_data = File.open(path, 'rt').read.encode('UTF-8')
      rescue
        raise 'ERROR: The input file does not exist. Check it.'
      end

      @dir = File.dirname(path)

      @article_id = begin
                      File.open("#{@dir}/id.txt", "rt").read.chomp
                    rescue
                      docdir = File.basename(@dir)
                      /^\d+$/ =~ docdir ? docdir : '■記事ID■'
                    end

      header, body = /\A((?:.|\n)*?)<%-- page -->/.match(input_data).yield_self do |m|
        if m.nil?
          ['', "\n\n" + Commons + "\n\n" + input_data]
        else
          [m[1], '<%-- page -->' + "\n\n" + Commons + "\n\n" + m.post_match]
        end
      end

      @article_id = $+ if header.sub!(/^■記事ID■[^0-9]+(\d+)$/, '')
      h = header.strip.split(/\n\n+/)
      @corner = set_header_item(h[0], '記事・ニュースのコーナー')
      @title  = set_header_item(h[1], 'タイトル' )
      @lead   = set_header_item(h[2], 'nil')
      @pic    = set_header_item(h[3], 'dummy.png')
      @author = set_header_item(h[4], '著者 クレジット')
      @css    = set_header_item(h[5], '')

      @pp_header = make_pp_header
      @converted = convert(body)
    end

    def set_header_item(target, default)
      if /\A\ufeff?[\-%]+\Z/ =~ target || target.nil?
        default.define_singleton_method(:is_complete?){ false }
        default
      else
        target.define_singleton_method(:is_complete?){ true }
        target
      end
    end

    def make_pp_header
      header_output = []
      header_output << "［コーナー］\n#{@corner}" if @corner.is_complete?
      header_output << "［タイトル］\n#{@title}" if @title.is_complete?
      header_output << "［リード］\n<p>#{@lead}</p>" if @lead.is_complete?
      header_output << "［タイトル画像］\n#{@pic}" if @pic.is_complete?
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

