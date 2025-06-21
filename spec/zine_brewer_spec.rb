# frozen_string_literal: true
#

require_relative '../lib/zine_brewer'

RSpec.describe ZineBrewer do
  it "has a version number" do
    expect(ZineBrewer::VERSION).not_to be nil
  end

  context "Test 01" do
    brewer = ZineBrewer.document.new
    brewer.convert("spec/testfiles/01/01_whole.txt")
    brewer.write_out
    it "has a document with whole elements" do
      expect(File.open("spec/testfiles/01/proof/body.txt").read.strip).to \
        eq File.open("spec/testfiles/01/01_body.txt").read.strip
    end
  
    it "puts the header file" do
      expect(File.open("spec/testfiles/01/proof/header.txt").read.strip).to \
        eq File.open("spec/testfiles/01/01_header.txt").read.strip
    end
  end

  context "Test 02" do
    brewer = ZineBrewer.document.new
    brewer.convert("spec/testfiles/02/02_definition_table_th_width.txt")
    brewer.write_out
    it "has a document with th width of the definition table" do
      expect(File.open("spec/testfiles/02/proof/body.txt").read.strip).to \
        eq File.open("spec/testfiles/02/02_body.txt").read.strip
    end
  
    it "puts the header file" do
      expect(File.open("spec/testfiles/02/proof/header.txt").read.strip).to \
        eq File.open("spec/testfiles/02/02_header.txt").read.strip
    end
  end

  context "Test 03" do
    brewer = ZineBrewer.document.new
    brewer.convert("spec/testfiles/03/03_whole.txt")
    brewer.write_out
    it "has a document with whole elements" do
      expect(File.open("spec/testfiles/03/proof/body.txt").read.strip).to \
        eq File.open("spec/testfiles/03/03_body.txt").read.strip
    end
  
    it "puts the header file" do
      expect(File.open("spec/testfiles/03/proof/header.txt").read.strip).to \
        eq File.open("spec/testfiles/03/03_header.txt").read.strip
    end
  end

  context "Test 04" do
    brewer = ZineBrewer.document.new
    brewer.convert("spec/testfiles/04/04_whole.txt")
    brewer.write_out
    it "has a document with whole elements" do
      expect(File.open("spec/testfiles/04/proof/body.txt").read.strip).to \
        eq File.open("spec/testfiles/04/04_body.txt").read.strip
    end
  
    it "puts the header file" do
      expect(File.open("spec/testfiles/04/proof/header.txt").read.strip).to \
        eq File.open("spec/testfiles/04/04_header.txt").read.strip
    end
  end

end
