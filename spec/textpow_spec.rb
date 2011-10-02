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

  describe "syntax" do
    it "has syntax files" do
      Dir["#{Textpow.syntax_path}/*.syntax"].should_not == []
    end

    Dir["#{Textpow.syntax_path}/*.syntax"].each do |syntax|
      it "#{syntax} can parse" do
        node = Textpow::SyntaxNode.load(syntax)
        node.parse("xxx\n1 + 1\n### xxx")
      end
    end
  end
end
