# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake"
gem "minitest"

group :rubocop do
  gem "rubocop", ">= 1.25.1", require: false
  gem "rubocop-minitest", require: false
  gem "rubocop-packaging", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
end

if ENV["TEST_WITH_OLD_DEPENDENCIES"]
  gem "nokogiri", "< 1.12.0"
  gem "loofah", "< 2.21.0"
end
