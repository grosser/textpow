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
    key = syntax_name.downcase
    if @@syntax.has_key?(key)
      @@syntax[key]
    else
      @@syntax[key] = uncached_syntax(syntax_name)
    end
  end

private

  def self.uncached_syntax(name)
    path = (
      find_syntax_by_path(name) ||
      find_syntax_by_scope_name(name.downcase) ||
      find_syntax_by_fuzzy_name(name.downcase)
    )
    SyntaxNode.load(path) if path
  end

  def self.find_syntax_by_scope_name(name)
    path = File.join(syntax_path, "#{name}.syntax")
    path if File.exist?(path)
  end

  def self.find_syntax_by_fuzzy_name(name)
    path = Dir.glob(File.join(syntax_path, "*.#{name}.*")).sort_by(&:size).first
    path if path and File.exist?(path)
  end

  def self.find_syntax_by_path(path)
    path if File.file?(path)
  end
end

