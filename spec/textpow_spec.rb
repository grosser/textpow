require 'spec_helper'

describe Textpow do
  it "has a version" do
    Textpow::Version =~ /^\d\.\d\.\d$/
  end
end
