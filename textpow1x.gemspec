# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "textpow/version"

Gem::Specification.new do |s|
  s.name                  = "textpow1x"
  s.version               = Textpow::Version
  s.authors               = ["Dizan Vasquez", "Spox", "Chris Hoffman", "Michael Grosser"]
  s.email                 = ["michael@grosser.it"]
  s.homepage              = "http://github.com/grosser/textpow"
  s.summary               = "A library for parsing TextMate bundles on ruby 1.x"
  s.description           = s.summary
  s.license               = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  s.executables = ["plist2yaml", "plist2syntax"]
  s.rdoc_options = ["--main", "README.rdoc"]

  s.add_dependency "plist", '>=3.0.1'
end
