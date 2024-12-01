# coding: utf-8
# frozen_string_literal: true

require_relative "lib/rails/html/sanitizer/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-html-sanitizer"
  spec.version       = Rails::HTML::Sanitizer::VERSION
  spec.authors       = ["Rafael Mendonça França", "Kasper Timm Hansen", "Mike Dalessio"]
  spec.email         = ["rafaelmfranca@gmail.com", "kaspth@gmail.com", "mike.dalessio@gmail.com"]
  spec.description   = "HTML sanitization for Rails applications"
  spec.summary       = "This gem is responsible to sanitize HTML fragments in Rails applications."
  spec.homepage      = "https://github.com/rails/rails-html-sanitizer"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata = {
    "bug_tracker_uri"   => "https://github.com/rails/rails-html-sanitizer/issues",
    "changelog_uri"     => "https://github.com/rails/rails-html-sanitizer/blob/v#{spec.version}/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/rails-html-sanitizer/#{spec.version}",
    "source_code_uri"   => "https://github.com/rails/rails-html-sanitizer/tree/v#{spec.version}",
  }

  spec.files         = Dir["lib/**/*", "README.md", "MIT-LICENSE", "CHANGELOG.md"]
  spec.test_files    = Dir["test/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "loofah", "~> 2.21"

  # A fix was shipped in nokogiri v1.15.7 and v1.16.8 without which there is a vulnerability in this gem.
  spec.add_dependency "nokogiri", [">=1.15.7",
                                   "!=1.16.0", "!=1.16.0.rc1", "!=1.16.1", "!=1.16.2", "!=1.16.3",
                                   "!=1.16.4", "!=1.16.5", "!=1.16.6", "!=1.16.7"]
end
