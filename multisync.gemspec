
# frozen_string_literal: true

require_relative "lib/multisync/version"

Gem::Specification.new do |spec|
  spec.name = "multisync"
  spec.version = Multisync::VERSION
  spec.authors = ["Patrick Marchi"]
  spec.email = ["mail@patrickmarchi.ch"]

  spec.summary = [spec.name, spec.version].join("-")
  spec.description = "A DSL to organize sets of rsync tasks."
  spec.homepage = "https://github.com/pmarchi/multisync"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = File.join(spec.homepage, "blob/main/CHANGELOG.md")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "mixlib-shellout"
  spec.add_dependency "filesize"
  spec.add_dependency "rainbow"
  spec.add_dependency "terminal-table"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
