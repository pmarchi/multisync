lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "multisync/version"

Gem::Specification.new do |spec|
  spec.name          = "multisync"
  spec.version       = Multisync::VERSION
  spec.authors       = ["Patrick Marchi"]
  spec.email         = ["mail@patrickmarchi.ch"]

  spec.summary       = %q{DSL for rsync.}
  spec.description   = %q{Multisync offers a DSL to organize sets of rsync tasks.}
  spec.homepage      = "https://github.com/pmarchi/multisync"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/pmarchi/multisync"
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mixlib-shellout"
  spec.add_dependency "filesize"
  spec.add_dependency "rainbow"
  spec.add_dependency "terminal-table"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
