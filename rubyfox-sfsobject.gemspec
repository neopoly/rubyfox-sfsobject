# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubyfox/sfsobject/version'

Gem::Specification.new do |gem|
  gem.name          = "rubyfox-sfsobject"
  gem.version       = Rubyfox::SFSObject::VERSION
  gem.authors       = ["Peter Suschlik"]
  gem.email         = ["ps@neopoly.de"]
  gem.description   = %q{Map SFSObject into Ruby Hash}
  gem.summary       = %q{}
  gem.homepage      = "https://github.com/neopoly/rubyfox-sfsobject"
  gem.platform      = Gem::Platform::CURRENT

  gem.files         = `git ls-files`.split($/).reject { |file| file =~ %r{test/vendor} }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'simple_assertions'
end
