require 'spec_helper'

describe "syntax files" do
  before do
    STDERR.stub!(:puts)
  end

  it "has syntax files" do
    Dir["#{Textpow.syntax_path}/*.syntax"].should_not == []
  end

  Dir["#{Textpow.syntax_path}/*.syntax"].each do |syntax|
    it "#{syntax} can parse" do
      Textpow.syntax(syntax).parse("xxx\n1 + 1\n### xxx")
    end
  end

  xit "parses markdown" do
    node = Textpow.syntax("lib/textpow/syntax/broken/markdown.syntax")
    node.parse("### xxx\nabc\n    xxx\nyyy\n - abc\n - ac").stack.should_not == []
  end
end
