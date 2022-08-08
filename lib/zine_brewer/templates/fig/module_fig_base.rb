# coding: utf-8

module Fig_00
  
  def imgs_list
    result = []
    (imgs rescue a_img_param).each do |h|
      a_img = {}
      raise "Error: No src:" if h["src"].nil?
      a_img[:fig_src] = make_src(h["src"])
      a_img[:href] = h["href"]
      a_img[:alt] = make_alt(h["alt"])
      a_img[:img_style] = make_img_style(h["width"], h["height"]) \
        unless h["width"].nil? && h["height"].nil?
      result << a_img
    end
    result
  end

  def caption
    begin
      cap.chomp.sub(/^\\/, '').gsub(/\n/,'<br/>')
    rescue
      nil
    end
  end

  def wraparound
    begin
      c = case wrap
          when 'imgL'
            'text-center float-md-start me-md-3 mb-3'
          when 'imgR'
            'text-center float-md-end ms-md-3 mb-3'
          else
            nil
          end
      c ? " class=\"#{c}\"" : ''
    rescue
      ''
    end
  end

  private
  def a_img_param
    [{"src" => (src rescue nil),
      "href" => (href rescue nil),
      "alt" => (alt rescue caption),
      "width" => (width rescue nil),
      "height" => (height rescue nil)}]
  end

  def make_src(l_src)
    case File.dirname(l_src)
    when ".", "images"
      f = File.basename(l_src)
      "/static/images/article/■記事ID■/#{/^\d+_/ =~ f ? f : '■記事ID■_' + f}"
    when "common"
      "/static/images/article/common/#{File.basename(l_src)}"
    else
      l_src
    end
  end

  def make_alt(l_alt)
    begin
      l_alt.gsub(/\[(.+?)\]\(.+?\)/, '\1').gsub(/\n/, '')
    rescue
      nil
    end
  end
  
  def make_img_style(l_width, l_height)
    s = []
    s << "width:#{l_width};" unless l_width.nil?
    s << "height:#{l_height};" unless l_height.nil?
    unless s.all?{|v| v.nil? }
      %Q{style="#{s.join(' ').strip}" }
    end
  end

end


