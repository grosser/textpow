require 'spec_helper'

describe "syntax files" do
  before do
    STDERR.stub!(:puts)
  end

  let(:processor){ Textpow::DebugProcessor.new }

  it "has syntax files" do
    Dir["#{Textpow.syntax_path}/*.syntax"].should_not == []
  end

  Dir["#{Textpow.syntax_path}/*.syntax"].each do |syntax|
    it "#{syntax} can parse" do
      node = Textpow::SyntaxNode.load(syntax)
      node.parse("xxx\n1 + 1\n### xxx", processor)
    end
  end

  # syntax broken in 1.9
  xit "parses markdown" do
    node = Textpow::SyntaxNode.load("#{Textpow.syntax_path}/broken/markdown.syntax")
    node.parse("### xxx\nabc\n    xxx\n    yyy\n - abc\n - ac", processor)
  end
end
