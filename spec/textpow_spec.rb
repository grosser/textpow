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
