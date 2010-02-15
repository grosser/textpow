# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{textpow}
  s.version = "0.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Hoffman", "Spox", "Dizan Vasquez"]
  s.date = %q{2010-02-15}
  s.description = %q{A library for parsing {TextMate}[http://macromates.com/] bundles.}
  s.email = ["cehoffman@gmail.com", "spox@modspox.com", "dichodaemon@gmail.com"]
  s.executables = ["plist2yaml", "plist2syntax"]
  s.extra_rdoc_files = ["Manifest.txt"]
  s.files = ["bin/plist2yaml", "bin/plist2syntax", "lib/textpow.rb", "lib/textpow", "lib/textpow/syntax.rb", "lib/textpow/version.rb", "lib/textpow/score_manager.rb", "lib/textpow/debug_processor.rb", "test/test_textpow.rb", "History.rdoc", "Rakefile", "Manifest.txt", "README.rdoc"]
  s.homepage = %q{http://github.com/cehoffman/textpow}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.0")
  s.rubyforge_project = %q{textpow}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A library for parsing {TextMate}[http://macromates.com/] bundles.}
  s.test_files = ["test/test_textpow.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<plist>, [">= 3.0.1"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_development_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.5.0"])
    else
      s.add_dependency(%q<plist>, [">= 3.0.1"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_dependency(%q<hoe>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<plist>, [">= 3.0.1"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
    s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
    s.add_dependency(%q<hoe>, [">= 2.5.0"])
  end
end
