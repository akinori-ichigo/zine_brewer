# frozen_string_literal: true
#

require_relative '../lib/zine_brewer'

RSpec.describe ZineBrewer do
  it "has a version number" do
    expect(ZineBrewer::VERSION).not_to be nil
  end
  
  it "read a markdown document" do
    expect(ZineBrewer::Application.new("spec/testfiles/01_test.txt")).to \
      eq File.open("spec/testfiles/01_result.inspect").read
  end
end
