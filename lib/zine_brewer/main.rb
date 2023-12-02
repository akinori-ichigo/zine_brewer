# coding: utf-8

require 'nkf'
require 'darkmouun'

require_relative 'kramdown/parser/sekd'
require_relative 'kramdown/converter/sehtml'

module ZineBrewer

  def convert(str)
    dkmn = Darkmouun.document.new
    dkmn.convert(str, {:auto_ids => false, :entity_output => :as_input, :input => 'sekd'}, :to_se_html)
  end

  def document
    ZineBrewer
  end

  module_function :convert, :document

  class ZineBrewer

    attr_reader :corner, :title, :lead, :pic, :author, :css, :converted

    def initialize(template_dir: nil)
      @dkmn = Darkmouun.document.new

      ### Sets templates
      template_dir.nil? || Dir['*.rb', base: template_dir].each do |t|
        @dkmn.add_template("#{template_dir}/#{t}")
      end

      ### Sets pre process
      @dkmn.pre_process = lambda do |t|
      end

      ### Sets post process
      @dkmn.post_process = lambda do |t|
        t.gsub!(/(?<!\\)&amp;null;/, '')
        t.gsub!('(((BR)))', '<br/>')
        t.gsub!(%r'src="(?!/static)([^"]+)"') do |s|
          mts = Regexp.last_match[1]
          if %r!^common/! =~ mts
            %!src="/static/images/article/#{mts}"!
          else
            aid, nm = mts.match(%r!(\d+)?_?(.+)!)[1..2]
            aid ||= '■記事ID■'
            %!src="/static/images/article/#{aid}/#{aid}_#{nm}"!
          end
        end
        t.gsub!(%r!<img[^>]+hrefsrc=(".+?").+?/>!) do |s|
          %!<a href=#{Regexp.last_match[1]} rel="lightbox" target="_blank" title="拡大画像">#{s.sub(/hrefsrc/, 'src')}</a>!
        end
        t.gsub!(/■記事ID■/, @article_id)
        t.gsub!(/[‘’]/, "'")
        t.gsub!(/<li>\\/, '<li>')
        if /<div id="p2">/ =~ t
          t << "</div>"
        else
          t.sub!(/<div id="p1">\n/, '')
        end
      end
    end

    def convert(path)
      begin
        input_data = file_read_convert_utf8(path)
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
      @pic = set_header_item(h[3], ''){|v| /^\./ =~ v ? v : "./images/#{@article_id}_#{v}" }
      @css = set_header_item(h[5], '') do |v|
        v.gsub!(/\&[^\.]+\.css/) do |i|
          file_read_convert_utf8("#{@dir}/css/#{i.strip.sub(/^\&\d*_*/, '')}") rescue ''
        end
        v.scan(/(?:\s*@media[^{]+{\s*)|(?:\s*}\s*)|(?:(?:\s*(?:[^,{]+)\s*,?\s*)*?){(?:(?:\s*(?:[^:]+)\s*:\s*(?:[^;]+?)\s*;\s*)*?)}\s*/).map do |i|
          /\A\s*[@}]/ =~ i ? i : '.c-article_content ' + i
        end.join.gsub(/\n\n+/, "\n")
      end

      @converted = @dkmn.convert(body, {:auto_ids => false, :entity_output => :as_input, :input => 'sekd', :smart_quotes => ["apos", "apos", "quot", "quot"]}, :to_se_html)
    end

    ## Writing out header and body as files in 'proof' directory
    def write_out
      proof_dir = @dir + '/proof'
      begin
        Dir.mkdir(proof_dir)
      rescue Errno::EEXIST
      end

      header_output = []
      header_output << "［コーナー］\n#{@corner}" if @corner.is_complete?
      header_output << "［タイトル］\n#{@title}" if @title.is_complete?
      header_output << "［リード］\n<p>#{@lead}</p>" if @lead.is_complete?
      header_output << "［タイトル画像］\n#{File.basename(@pic)}" if @pic.is_complete?
      header_output << "［著者クレジット］\n#{@author}" if @author.is_complete?
      header_output << "［追加CSS］\n#{@css}" if @css.is_complete?
      File.open("#{proof_dir}/header.txt", 'wb') do |f|
        f.write(header_output.join("\n\n"))
      end

      File.open("#{proof_dir}/body.txt", 'wb') do |f|
        f.write(@converted.gsub("<!-- page_delimiter -->\n", ''))
      end
    end

    private

    def file_read_convert_utf8(path)
      _doc = File.open(path, 'rt'){|f| f.read }
      _doc.force_encoding(NKF.guess(_doc)).encode('utf-8')
    end

    def set_header_item(value, alt)
      if /^\ufeff?-{2,}/ =~ value || value.nil?
        alt.define_singleton_method(:is_complete?){ false }
        alt
      else
        value = yield(value) if block_given?
        value.define_singleton_method(:is_complete?){ true }
        value
      end
    end

  end
end

