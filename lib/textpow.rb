require 'yaml'
require 'textpow/syntax'
require 'textpow/debug_processor'
require 'textpow/score_manager'
require 'textpow/version'

module Textpow
  class ParsingError < Exception; end

  def syntax_path
    File.expand_path(__FILE__, x)
  end
end

