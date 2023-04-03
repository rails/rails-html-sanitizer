source 'https://rubygems.org'

gemspec

gem "rake"
gem "minitest"
gem "rails-dom-testing"

group :rubocop do
  gem "rubocop", ">= 1.25.1", require: false
  gem "rubocop-minitest", require: false
  gem "rubocop-packaging", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end

# specify gem versions for old rubies
gem "nokogiri", RUBY_VERSION < "2.1" ? "~> 1.6.0" : ">= 1.7"
gem "activesupport", RUBY_VERSION < "2.2.2" ? "~> 4.2.0" : ">= 5"
