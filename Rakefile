require "bundler"
Bundler::GemHelper.install_tasks

task :default do
  sh "rspec spec/"
end

desc "Convert a plist to a .syntax file"
task :convert, :in, :out do |t,args|
  convert(args[:in], args[:out] || 'out.syntax')
end

rule /^version:bump:.*/ do |t|
  sh "git status | grep 'nothing to commit'" # ensure we are not dirty
  index = ['major', 'minor','patch'].index(t.name.split(':').last)
  file = 'lib/textpow/version.rb'

  version_file = File.read(file)
  old_version, *version_parts = version_file.match(/(\d+)\.(\d+)\.(\d+)/).to_a
  version_parts[index] = version_parts[index].to_i + 1
  new_version = version_parts * '.'
  File.open(file,'w'){|f| f.write(version_file.sub(old_version, new_version)) }

  sh "bundle && git add #{file} Gemfile.lock && git commit -m 'bump version to #{new_version}'"
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
