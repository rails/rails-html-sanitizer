# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake"
gem "minitest"

# MT6 restricts supported versions, therefore older Rubies sticks with MT5,
# which includes `minitest/mock`
if RUBY_VERSION >= "3.2"
  gem "minitest-mock"
end

group :rubocop do
  gem "rubocop", ">= 1.25.1", require: false
  gem "rubocop-minitest", require: false
  gem "rubocop-packaging", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end
