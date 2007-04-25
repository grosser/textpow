require 'rubygems'
require 'hoe'

class Hoe 
   # Dirty hack to eliminate Hoe from gem dependencies
   def extra_deps 
      @extra_deps.delete_if{ |x| x.first == 'hoe' }
   end
end

version = /^== *(\d+\.\d+\.\d+)/.match( File.read( 'History.txt' ) )[1]

h = Hoe.new('textpow', version) do |p|
  p.rubyforge_name = 'textpow'
  p.author = ['Dizan Vasquez']
  p.email  = ['dichodaemon@gmail.com']
  p.email = 'dichodaemon@gmail.com'
  p.summary = 'An engine for parsing Textmate bundles'
  p.description = p.paragraphs_of('README.txt', 1 ).join('\n\n')
  p.url = 'http://textpow.rubyforge.org'
  p.rdoc_pattern = /^(lib|bin|ext)|txt$/
  p.changes = p.paragraphs_of('History.txt', 0).join("\n\n")
  p.extra_deps << ['oniguruma', '>= 1.1.0']
end
