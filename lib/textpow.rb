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

  def self.syntax(syntax_name)
    file = File.join(syntax_path, "#{syntax_name}.syntax".downcase)
    return unless File.exist?(file)
    SyntaxNode.load(file)
  end
end

