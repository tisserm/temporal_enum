# frozen_string_literal: true

require_relative "lib/temporal_enum/version"

Gem::Specification.new do |spec|
  spec.name = "temporal_enum"
  spec.version = TemporalEnum::VERSION
  spec.authors = ["Maxence Tisserant"]
  spec.email = ["maxence.tisserant@gmail.com"]

  spec.summary = "Add new methods for ActiveRecord Enum with a temporal progression"
  spec.description = "Add new methods and scopes for ActiveRecord Enum with a temporal progression"
  spec.homepage = "https://github.com/tisserm/temporal_enum"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "http://localhost:3000"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tisserm/temporal_enum"
  spec.metadata["changelog_uri"] = "https://github.com/tisserm/temporal_enum/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activerecord", ">= 7.0.0"

  spec.add_development_dependency "sqlite3", "~> 1.4"
  spec.add_development_dependency "with_model", "~> 2.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
