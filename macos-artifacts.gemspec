# frozen_string_literal: true

require_relative "lib/macos/artifacts/version"
require_relative "lib/macos/artifacts/state"
require_relative "lib/macos/artifacts/files"

Gem::Specification.new do |spec|
  spec.name     = "macos-artifacts"
  spec.version  = Macos::Artifacts::VERSION
  spec.authors  = ["nic scott"]
  spec.email    = ["nls.inbox@gmail.com"]
  spec.summary  = %q{A collection of macOS artifacts}
  spec.homepage = "https://github.com/nlscott/macos-artifacts"
  spec.license  = "MIT"
  spec.required_ruby_version = ">= 2.6.0"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency "bundler", ">= 2.2.33"
  spec.add_development_dependency "CFPropertyList", ">= 3.0.6"
end
