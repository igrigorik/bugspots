# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bugspots/version"

Gem::Specification.new do |s|
  s.name        = "bugspots"
  s.version     = Bugspots::VERSION
  s.authors     = ["Ilya Grigorik"]
  s.email       = ["ilya@igvita.com"]
  s.homepage    = "https://github.com/igrigorik/bugspots"
  s.summary     = "Implementation of simple bug prediction hotspot heuristic"
  s.description = s.summary

  s.rubyforge_project = "bugspots"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "grit"
  s.add_dependency "rainbow"
  
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
