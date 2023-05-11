# frozen_string_literal: true

require "minitest/autorun"
require "rails-html-sanitizer"

class RailsApiTest < Minitest::Test
  def test_html_module_name_alias
    assert_equal(Rails::Html, Rails::HTML)
    assert_equal("Rails::HTML", Rails::Html.name)
    assert_equal("Rails::HTML", Rails::HTML.name)
  end

  def test_html_scrubber_class_names
    assert(Rails::Html::PermitScrubber)
    assert(Rails::Html::TargetScrubber)
    assert(Rails::Html::TextOnlyScrubber)
    assert(Rails::Html::Sanitizer)
  end

  def test_full_sanitizer_returns_a_full_sanitizer
    assert_equal(Rails::Html::FullSanitizer, Rails::Html::Sanitizer.full_sanitizer)
  end

  def test_link_sanitizer_returns_a_link_sanitizer
    assert_equal(Rails::Html::LinkSanitizer, Rails::Html::Sanitizer.link_sanitizer)
  end

  def test_safe_list_sanitizer_returns_a_safe_list_sanitizer
    assert_equal(Rails::Html::SafeListSanitizer, Rails::Html::Sanitizer.safe_list_sanitizer)
  end

  def test_white_list_sanitizer_returns_a_safe_list_sanitizer
    assert_equal(Rails::Html::SafeListSanitizer, Rails::Html::Sanitizer.white_list_sanitizer)
  end
end
