$LOAD_PATH.unshift 'lib'
require 'textpow'

syntax = Textpow::SyntaxNode.load("#{Textpow.syntax_path}/javascript.syntax")
text = File.read('examples/jquery.js')
processor = Textpow::RecordingProcessor.new

start = Time.now.to_f
1.times{ syntax.parse(text,  processor) }
puts Time.now.to_f - start

