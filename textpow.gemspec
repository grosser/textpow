name = "textpow"
require "./lib/#{name}/version"

Gem::Specification.new name, Textpow::Version do |s|
  s.authors               = ["Dizan Vasquez", "Spox", "Chris Hoffman", "Michael Grosser"]
  s.email                 = ["michael@grosser.it"]
  s.homepage              = "https://github.com/grosser/#{name}"
  s.summary               = "A library for parsing TextMate bundles"
  s.description           = s.summary
  s.license               = "MIT"

  s.files         = `git ls-files bin lib README.rdoc MIT-LICENSE.txt`.split("\n")
  s.executables = ["plist2yaml", "plist2syntax"]
  s.rdoc_options = ["--main", "README.rdoc"]

  s.add_runtime_dependency "plist", '>=3.0.1'
  s.required_ruby_version = ">= 1.9.3"
end
