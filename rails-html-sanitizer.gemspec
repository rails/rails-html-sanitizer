# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/html/sanitizer/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-html-sanitizer"
  spec.version       = Rails::Html::Sanitizer::VERSION
  spec.authors       = ["Rafael Mendonça França", "Kasper Timm Hansen"]
  spec.email         = ["rafaelmfranca@gmail.com", "kaspth@gmail.com"]
  spec.description   = %q{HTML sanitization for Rails applications}
  spec.summary       = %q{This gem is responsible to sanitize HTML fragments in Rails applications.}
  spec.homepage      = "https://github.com/rails/rails-html-sanitizer"
  spec.license       = "MIT"
  
  spec.required_ruby_version = '>= 2.6'

  spec.metadata      = {
    "bug_tracker_uri"   => "https://github.com/rails/rails-html-sanitizer/issues",
    "changelog_uri"     => "https://github.com/rails/rails-html-sanitizer/blob/v#{spec.version}/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/rails-html-sanitizer/#{spec.version}",
    "source_code_uri"   => "https://github.com/rails/rails-html-sanitizer/tree/v#{spec.version}",
  }

  spec.files         = Dir["lib/**/*", "README.md", "MIT-LICENSE", "CHANGELOG.md"]
  spec.test_files    = Dir["test/**/*"]
  spec.require_paths = ["lib"]

  # NOTE: There's no need to update this dependency for Loofah CVEs
  # in minor releases when users can simply run `bundle update loofah`.
  spec.add_dependency "loofah", "~> 2.3"

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rails-dom-testing"
end
