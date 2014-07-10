# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multisync/version'

Gem::Specification.new do |spec|
  spec.name          = "multisync"
  spec.version       = Multisync::VERSION
  spec.authors       = ["Patrick Marchi"]
  spec.email         = ["mail@patrickmarchi.ch"]
  spec.summary       = %q{Manage rsync configurations in sets of rules.}
  spec.description   = %q{Manage rsync configurations organized in groups with inherited options.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "shell_cmd"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler_geminabox"
end
