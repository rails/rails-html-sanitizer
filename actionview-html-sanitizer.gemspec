# coding: utf-8
# frozen_string_literal: true

require_relative "lib/action_view/html/sanitizer/version"

Gem::Specification.new do |spec|
  spec.name          = "actionview-html-sanitizer"
  spec.version       = ActionView::HTML::Sanitizer::VERSION
  spec.authors       = ["Rafael Mendonça França", "Kasper Timm Hansen", "Mike Dalessio"]
  spec.email         = ["rafaelmfranca@gmail.com", "kaspth@gmail.com", "mike.dalessio@gmail.com"]
  spec.description   = "HTML sanitization for ActionView applications"
  spec.summary       = "This gem is responsible to sanitize HTML fragments in ActionView applications."
  spec.homepage      = "https://github.com/rails/actionview-html-sanitizer"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata = {
    "bug_tracker_uri"   => "https://github.com/rails/actionview-html-sanitizer/issues",
    "changelog_uri"     => "https://github.com/rails/actionview-html-sanitizer/blob/v#{spec.version}/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/actionview-html-sanitizer/#{spec.version}",
    "source_code_uri"   => "https://github.com/rails/actionview-html-sanitizer/tree/v#{spec.version}",
  }

  spec.files         = Dir["lib/**/*", "README.md", "MIT-LICENSE", "CHANGELOG.md"]
  spec.test_files    = Dir["test/**/*"]
  spec.require_paths = ["lib"]

  # NOTE: There's no need to update dependencies for CVEs in minor releases
  # when users can simply run `bundle update loofah`.
  spec.add_dependency "loofah", "~> 2.21"
  spec.add_dependency "nokogiri", "~> 1.14"
end
