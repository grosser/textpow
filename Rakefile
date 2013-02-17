require "bundler/setup"
require "bundler/gem_tasks"
require "bump/tasks"

task :default do
  sh "rspec spec/"
end

desc "Convert a plist to a .syntax file"
task :convert, :in, :out do |t,args|
  convert(args[:in], args[:out] || 'out.syntax')
end

desc "update syntaxes from their original source"
task :update_syntax do
  {
    'source.scss' => 'https://raw.github.com/kuroir/SCSS.tmbundle/master/Syntaxes/SCSS.tmLanguage'
  }.each do |scope_name, url|
    `curl '#{url}' > temp.plist`
    convert('temp.plist', "lib/textpow/syntax/#{scope_name}.syntax")
    `rm temp.plist`
  end
end

def convert(from, to)
  require 'plist'
  require 'yaml'
  yaml = Plist.parse_xml(from).to_yaml
  File.open(to,'w'){|f| f.write(yaml) }
end
