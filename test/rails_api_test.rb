# frozen_string_literal: true

require "minitest/autorun"
require "actionview-html-sanitizer"

class ActionViewApiTest < Minitest::Test
  def test_html_module_name_alias
    assert_equal(ActionView::Html, ActionView::HTML)
    assert_equal("ActionView::HTML", ActionView::Html.name)
    assert_equal("ActionView::HTML", ActionView::HTML.name)
  end

  def test_html_scrubber_class_names
    assert(ActionView::Html::PermitScrubber)
    assert(ActionView::Html::TargetScrubber)
    assert(ActionView::Html::TextOnlyScrubber)
    assert(ActionView::Html::Sanitizer)
  end

  def test_best_supported_vendor_when_html5_is_not_supported_returns_html4
    ActionView::HTML::Sanitizer.stub(:html5_support?, false) do
      assert_equal(ActionView::HTML4::Sanitizer, ActionView::HTML::Sanitizer.best_supported_vendor)
    end
  end

  def test_best_supported_vendor_when_html5_is_supported_returns_html5
    skip("no HTML5 support on this platform") unless ActionView::HTML::Sanitizer.html5_support?

    ActionView::HTML::Sanitizer.stub(:html5_support?, true) do
      assert_equal(ActionView::HTML5::Sanitizer, ActionView::HTML::Sanitizer.best_supported_vendor)
    end
  end

  def test_html4_sanitizer_alias_full
    assert_equal(ActionView::HTML4::FullSanitizer, ActionView::HTML::FullSanitizer)
    assert_equal("ActionView::HTML4::FullSanitizer", ActionView::HTML::FullSanitizer.name)
  end

  def test_html4_sanitizer_alias_link
    assert_equal(ActionView::HTML4::LinkSanitizer, ActionView::HTML::LinkSanitizer)
    assert_equal("ActionView::HTML4::LinkSanitizer", ActionView::HTML::LinkSanitizer.name)
  end

  def test_html4_sanitizer_alias_safe_list
    assert_equal(ActionView::HTML4::SafeListSanitizer, ActionView::HTML::SafeListSanitizer)
    assert_equal("ActionView::HTML4::SafeListSanitizer", ActionView::HTML::SafeListSanitizer.name)
  end

  def test_html4_full_sanitizer
    assert_equal(ActionView::HTML4::FullSanitizer, ActionView::HTML::Sanitizer.full_sanitizer)
    assert_equal(ActionView::HTML4::FullSanitizer, ActionView::HTML4::Sanitizer.full_sanitizer)
  end

  def test_html4_link_sanitizer
    assert_equal(ActionView::HTML4::LinkSanitizer, ActionView::HTML::Sanitizer.link_sanitizer)
    assert_equal(ActionView::HTML4::LinkSanitizer, ActionView::HTML4::Sanitizer.link_sanitizer)
  end

  def test_html4_safe_list_sanitizer
    assert_equal(ActionView::HTML4::SafeListSanitizer, ActionView::HTML::Sanitizer.safe_list_sanitizer)
    assert_equal(ActionView::HTML4::SafeListSanitizer, ActionView::HTML4::Sanitizer.safe_list_sanitizer)
  end

  def test_html4_white_list_sanitizer
    assert_equal(ActionView::HTML4::SafeListSanitizer, ActionView::HTML::Sanitizer.white_list_sanitizer)
    assert_equal(ActionView::HTML4::SafeListSanitizer, ActionView::HTML4::Sanitizer.white_list_sanitizer)
  end

  def test_html5_full_sanitizer
    skip("no HTML5 support on this platform") unless ActionView::HTML::Sanitizer.html5_support?
    assert_equal(ActionView::HTML5::FullSanitizer, ActionView::HTML5::Sanitizer.full_sanitizer)
  end

  def test_html5_link_sanitizer
    skip("no HTML5 support on this platform") unless ActionView::HTML::Sanitizer.html5_support?
    assert_equal(ActionView::HTML5::LinkSanitizer, ActionView::HTML5::Sanitizer.link_sanitizer)
  end

  def test_html5_safe_list_sanitizer
    skip("no HTML5 support on this platform") unless ActionView::HTML::Sanitizer.html5_support?
    assert_equal(ActionView::HTML5::SafeListSanitizer, ActionView::HTML5::Sanitizer.safe_list_sanitizer)
  end

  def test_html5_white_list_sanitizer
    skip("no HTML5 support on this platform") unless ActionView::HTML::Sanitizer.html5_support?
    assert_equal(ActionView::HTML5::SafeListSanitizer, ActionView::HTML5::Sanitizer.white_list_sanitizer)
  end
end
