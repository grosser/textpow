require 'rubygems'

begin
   require 'hoe'
   require File.expand_path("../lib/textpow/version", __FILE__)

   Hoe.plugin :gemcutter

   Hoe.spec 'textpow' do
      developer("Chris Hoffman", "cehoffman@gmail.com")
      developer("Spox", "spox@modspox.com")
      developer("Dizan Vasquez", "dichodaemon@gmail.com")
      
      self.version = Textpow::Version
      self.extra_deps << ['plist', '>= 3.0.1']
      self.readme_file  = "README.rdoc"
      self.history_file = "History.rdoc"
      spec_extras[:required_ruby_version] = ">= 1.9.0"
   end
   
   task :gemspec do
     sh %{rake debug_gem | grep -v "(in " > `basename \\\`pwd\\\``.gemspec}
   end

rescue LoadError => e
   desc 'Run the test suite.'
   task :test do
      system "ruby -Ibin:lib:test test_#{rubyforge_name}.rb"
   end
end
