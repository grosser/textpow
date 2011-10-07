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

  @@syntax = {}
  def self.syntax(syntax_name)
    syntax_name = syntax_name.downcase
    if @@syntax.has_key?(syntax_name)
      @@syntax[syntax_name]
    else
      @@syntax[syntax_name] = uncached_syntax(syntax_name)
    end
  end

private

  def self.uncached_syntax(syntax_name)
    # try by scopeName
    file = File.join(syntax_path, "#{syntax_name}.syntax".downcase)

    # try by language name
    if not File.exist?(file)
      file = Dir.glob(File.join(syntax_path, "*.#{syntax_name}.*")).sort_by(&:size).first
      return if not file or not File.exist?(file)
    end

    SyntaxNode.load(file)
  end
end

