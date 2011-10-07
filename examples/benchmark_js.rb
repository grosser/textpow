# test changes for performance
# ruby examples/benchmark_js.rb 100; git co lib/textpow/syntax.rb ; ruby examples/benchmark_js.rb 100
$LOAD_PATH.unshift 'lib'
require 'textpow'

syntax = Textpow.syntax('javascript')
text = File.read('examples/jquery.js')
processor = Textpow::RecordingProcessor.new

start = Time.now.to_f
(ARGV[0] || 1).to_i.times{ syntax.parse(text,  processor) }
puts Time.now.to_f - start

