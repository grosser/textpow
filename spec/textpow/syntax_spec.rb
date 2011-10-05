require 'spec_helper'

describe Textpow::SyntaxNode do
  describe "#load" do
    it "can load from xml .plist" do
      Textpow::SyntaxNode.load('spec/fixtures/objeck.plist').should_not == nil
    end

    it "can load from yaml .syntax" do
      Textpow::SyntaxNode.load('lib/textpow/syntax/ruby.syntax').should_not == nil
    end
  end
end
