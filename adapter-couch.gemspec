# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "adapter/couch/version"

Gem::Specification.new do |s|
  s.name        = "adapter-couch"
  s.version     = Adapter::Couch::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pelle Braendgaard"]
  s.email       = ["pelle@stakeventures.com"]
  s.homepage    = ""
  s.summary     = %q{Adapter for couch}
  s.description = %q{Adapter for couch}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'adapter', '~> 0.5.1'
  s.add_dependency 'couchrest', '~> 1.1.0.pre2'
end
