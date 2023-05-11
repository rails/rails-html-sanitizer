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

  def test_html4_sanitizer_alias_full
    assert_equal(Rails::HTML4::FullSanitizer, Rails::HTML::FullSanitizer)
    assert_equal("Rails::HTML4::FullSanitizer", Rails::HTML::FullSanitizer.name)
  end

  def test_html4_sanitizer_alias_link
    assert_equal(Rails::HTML4::LinkSanitizer, Rails::HTML::LinkSanitizer)
    assert_equal("Rails::HTML4::LinkSanitizer", Rails::HTML::LinkSanitizer.name)
  end

  def test_html4_sanitizer_alias_safe_list
    assert_equal(Rails::HTML4::SafeListSanitizer, Rails::HTML::SafeListSanitizer)
    assert_equal("Rails::HTML4::SafeListSanitizer", Rails::HTML::SafeListSanitizer.name)
  end

  def test_full_sanitizer_returns_a_full_sanitizer
    assert_equal(Rails::HTML4::FullSanitizer, Rails::HTML::Sanitizer.full_sanitizer)
  end

  def test_link_sanitizer_returns_a_link_sanitizer
    assert_equal(Rails::HTML4::LinkSanitizer, Rails::HTML::Sanitizer.link_sanitizer)
  end

  def test_safe_list_sanitizer_returns_a_safe_list_sanitizer
    assert_equal(Rails::HTML4::SafeListSanitizer, Rails::HTML::Sanitizer.safe_list_sanitizer)
  end

  def test_white_list_sanitizer_returns_a_safe_list_sanitizer
    assert_equal(Rails::HTML4::SafeListSanitizer, Rails::HTML::Sanitizer.white_list_sanitizer)
  end
end
