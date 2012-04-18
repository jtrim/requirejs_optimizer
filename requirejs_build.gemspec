# -*- encoding: utf-8 -*-
require File.expand_path('../lib/requirejs_build/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jesse Trimble"]
  gem.email         = ["jesseltrimble@gmail.com"]
  gem.description   = %q{A tool for optimizing Require.js modules using r.js. NOTE: currently a WIP, not for production use}
  gem.summary       = %q{A tool for optimizing Require.js modules using r.js. NOTE: currently a WIP, not for production use}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "requirejs_build"
  gem.require_paths = ["lib"]
  gem.version       = RequirejsBuild::VERSION
end
