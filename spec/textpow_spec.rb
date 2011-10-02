require 'spec_helper'

describe Textpow::ScoreManager do
  # TODO legacy test
  it "calculates scores" do
    sp = Textpow::ScoreManager.new
    reference_scope = 'text.html.basic source.php.embedded.html string.quoted.double.php'

    sp.score('source.php string', reference_scope).should_not == 0
    sp.score('text.html source.php', reference_scope).should_not == 0
    sp.score('string source.php', reference_scope).should == 0
    sp.score('source.php text.html', reference_scope).should == 0

    sp.score('text.html source.php - string', reference_scope).should == 0
    sp.score('text.html source.php - ruby', reference_scope ).should_not == 0

    sp.score('string', reference_scope).should > sp.score('source.php', reference_scope)
    sp.score('string.quoted', reference_scope).should > sp.score('source.php', reference_scope)
    sp.score('text source string', reference_scope).should > sp.score( 'source string', reference_scope)
  end
end

describe Textpow do
  describe "syntax" do
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
end
