require 'spec_helper'

describe Textpow do
  it "has a version" do
    Textpow::Version =~ /^\d\.\d\.\d$/
  end

  it "has syntax files named after their scopeName" do
    Dir["#{Textpow.syntax_path}/*"].each do |file|
      next if File.directory?(file)
      (YAML.load_file(file)['scopeName'] + '.syntax').should == File.basename(file)
    end
  end

  describe "syntax" do
    it "finds a syntax by scopeName" do
      Textpow.syntax('source.ruby').name.should == 'Ruby'
    end

    it "finds a syntax by name parts" do
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
