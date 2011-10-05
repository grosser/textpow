require 'yaml'
require 'textpow/syntax'
require 'textpow/debug_processor'
require 'textpow/recording_processor'
require 'textpow/score_manager'
require 'textpow/version'

module Textpow
  class ParsingError < Exception; end

  def self.syntax_path
    File.join(File.dirname(__FILE__), 'textpow', 'syntax')
  end
end

