# frozen_string_literal: true
#

require_relative '../lib/zine_brewer'

RSpec.describe ZineBrewer do
  it "has a version number" do
    expect(ZineBrewer::VERSION).not_to be nil
  end
  
  it "has a document with whole elements" do
    expect(ZineBrewer::Application.new("spec/testfiles/01_whole.txt").pretty_print.strip).to \
      eq File.open("spec/testfiles/01_whole.html").read.strip
  end

  it "puts the header file" do
    expect(ZineBrewer::Application.new("spec/testfiles/01_whole.txt").make_pp_header.strip).to \
      eq File.open("spec/testfiles/01_header.txt").read.strip
  end

  it "has the width attribute of <th> element at 1st column" do
    expect(ZineBrewer::Application.new("spec/testfiles/02_definition_table_th_width.txt").pretty_print.strip).to \
      eq File.open("spec/testfiles/02_definition_table_th_width.html").read.strip
  end

  it "puts the header file again" do
    expect(ZineBrewer::Application.new("spec/testfiles/03_whole.txt").make_pp_header.strip).to \
      eq File.open("spec/testfiles/03_header.txt").read.strip
  end

  it "has the book introduction column correctly" do
    expect(ZineBrewer::Application.new("spec/testfiles/04_whole.txt").pretty_print.strip).to \
      eq File.open("spec/testfiles/04_book_column.html").read.strip
  end

end
