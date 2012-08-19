$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "textpow/version"

Gem::Specification.new do |s|
  s.name                  = "textpow"
  s.version               = Textpow::Version
  s.authors               = ["Dizan Vasquez", "Spox", "Chris Hoffman", "Michael Grosser"]
  s.email                 = ["michael@grosser.it"]
  s.homepage              = "http://github.com/grosser/textpow"
  s.summary               = "A library for parsing TextMate bundles"
  s.description           = s.summary
  s.license               = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.executables = ["plist2yaml", "plist2syntax"]
  s.rdoc_options = ["--main", "README.rdoc"]

  s.add_dependency "plist", '>=3.0.1'
end
