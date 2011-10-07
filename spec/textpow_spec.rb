require 'spec_helper'

describe Textpow do
  it "has a version" do
    Textpow::Version =~ /^\d\.\d\.\d$/
  end

  describe "syntax" do
    it "returns the found syntax" do
      Textpow.syntax('ruby').name.should == 'Ruby'
    end

    it "returns the found syntax for mixed case" do
      Textpow.syntax('RuBy').name.should == 'Ruby'
    end

    it "returns nil for unfound syntax" do
      Textpow.syntax('buby').should == nil
    end
  end
end
