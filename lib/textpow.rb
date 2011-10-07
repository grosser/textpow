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
    syntax_name = syntax_name.downcase

    # try by scopeName
    file = File.join(syntax_path, "#{syntax_name}.syntax".downcase)

    # try by language name
    if not File.exist?(file)
      file = Dir[File.join(syntax_path, "*.#{syntax_name}.*")].sort_by(&:size).first
      return if not file or not File.exist?(file)
    end

    SyntaxNode.load(file)
  end
end

