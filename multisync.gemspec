lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "multisync/version"

Gem::Specification.new do |spec|
  spec.name          = "multisync"
  spec.version       = Multisync::VERSION
  spec.authors       = ["Patrick Marchi"]
  spec.email         = ["mail@patrickmarchi.ch"]

  spec.summary       = %q{Manage rsync configurations in sets of rules.}
  spec.description   = %q{Manage rsync configurations organized in groups with inherited options.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
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

  spec.add_runtime_dependency "mixlib-shellout"
  spec.add_runtime_dependency "filesize"
  spec.add_runtime_dependency "rainbow"
  spec.add_runtime_dependency "terminal-table"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "bundler_geminabox"
  spec.add_development_dependency "pry"
end
