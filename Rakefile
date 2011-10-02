require "bundler"
Bundler::GemHelper.install_tasks

task :default do
  sh "rspec spec/"
end

desc "Convert a plist to a .syntax file"
task :convert, :file do |t,args|
  require 'plist'
  require 'yaml'
  yaml = Plist.parse_xml(args[:file]).to_yaml
  File.open('out.syntax','w'){|f| f.write(yaml) }
end
