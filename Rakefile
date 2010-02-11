require 'rubygems'

begin
   require 'hoe'
   require File.expand_path("../lib/textpow/version", __FILE__)
      
   Hoe.spec 'textpow' do
      developer("Chris Hoffman", "cehoffman@gmail.com")
      developer("Spox", "spox@modspox.com")
      developer("Dizan Vasquez", "dichodaemon@gmail.com")
      
      self.version = Textpow::Version
      self.extra_deps << ['spox-plist', '>= 3.0.0']
      self.readme = "README.rdoc"
      spec_extras[:required_ruby_version] = ">= 1.9.0"
   end

rescue LoadError => e
   desc 'Run the test suite.'
   task :test do
      system "ruby -Ibin:lib:test test_#{rubyforge_name}.rb"
   end
end