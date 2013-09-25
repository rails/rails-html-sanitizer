# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'html/sanitizer/version'

Gem::Specification.new do |spec|
  spec.name          = "html-sanitizer"
  spec.version       = Html::Sanitizer::VERSION
  spec.authors       = ["Rafael Mendonça França", "Kasper Timm Hansen"]
  spec.email         = ["rafaelmfranca@gmail.com", "kaspth@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "README.md", "LICENSE.txt"]
  spec.executables   = []
  spec.test_files    = Dir["test/**/*"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
