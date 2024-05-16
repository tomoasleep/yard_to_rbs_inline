# frozen_string_literal: true

require_relative "lib/yard_to_rbs_inline/version"

Gem::Specification.new do |spec|
  spec.name = "yard_to_rbs_inline"
  spec.version = YardToRbsInline::VERSION
  spec.authors = ["Tomoya Chiba"]
  spec.email = ["tomo.asleep@gmail.com"]

  spec.summary = "Converter of yard to rbs-inline"
  spec.description = "Converter of yard to rbs-inline"
  spec.homepage = "https://github.com/tomoasleep/yard_to_rbs_inline"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tomoasleep/yard_to_rbs_inline"
  spec.metadata["changelog_uri"] = "https://github.com/tomoasleep/yard_to_rbs_inline/blob/main/CHANGELOG.md"

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
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "yard"

  spec.add_development_dependency "bump"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
