module Rails
  # Rails::Html::Sanitizer includes three sanitizers
  # FullSanitizer, LinkSanitizer and WhiteListSanitizer
  #
  # === Rails::Html::FullSanitizer
  # Removes all tags but strips out scripts, forms and comments.
  #
  # full_sanitizer = Rails::Html::FullSanitizer.new
  # full_sanitizer.sanitize("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...")
  # # => Bold no more!  See more here...
  #
  # === Rails::Html::LinkSanitizer
  # Removes links and href attributes leaving only the link text
  #
  # link_sanitizer = Rails::Html::LinkSanitizer.new
  # link_sanitizer.sanitize('<a href="example.com">Only the link text will be kept.</a>')
  # # => Only the link text will be kept.
  #
  # === Rails::Html::WhiteListSanitizer
  #
  # white_list_sanitizer = Rails::Html::WhiteListSanitizer.new
  #
  # # sanitize via an extensive white list of allowed elements
  # white_list_sanitizer.sanitize(@article.body)
  #
  # # white list only the supplied tags and attributes
  # white_list_sanitizer.sanitize(@article.body, tags: %w(table tr td), attributes: %w(id class style))
  #
  # # white list via a custom scrubber
  # white_list_sanitizer.sanitize(@article.body, scrubber: ArticleScrubber.new)
  #
  # # white list sanitizer can also sanitize css
  # white_list_sanitizer.sanitize_css('background-color: #000;')
  module Html
    XPATHS_TO_REMOVE = %w{.//script .//form comment()}

    class Sanitizer # :nodoc:
      def sanitize(html, options = {})
        raise NotImplementedError, "subclasses must implement sanitize method."
      end

      private

      # call +remove_xpaths+ with string and get a string back
      # call it with a node or nodeset and get back a node/nodeset
      def remove_xpaths(html, xpaths)
        if html.respond_to?(:xpath)
          html.xpath(*xpaths).remove
          html
        else
          remove_xpaths(Loofah.fragment(html), xpaths).to_s
        end
      end
    end

    class FullSanitizer < Sanitizer
      def sanitize(html, options = {})
        return unless html
        return html if html.empty?

        Loofah.fragment(html).tap do |fragment|
          remove_xpaths(fragment, XPATHS_TO_REMOVE)
        end.text
      end
    end

    class LinkSanitizer < Sanitizer
      def initialize
        @link_scrubber = TargetScrubber.new
        @link_scrubber.tags = %w(a href)
      end

      def sanitize(html, options = {})
        Loofah.scrub_fragment(html, @link_scrubber).to_s
      end
    end

    class WhiteListSanitizer < Sanitizer
      def initialize
        @permit_scrubber = PermitScrubber.new
      end

      def sanitize(html, options = {})
        return unless html
        return html if html.empty?

        loofah_fragment = Loofah.fragment(html)

        if scrubber = options[:scrubber]
          # No duck typing, Loofah ensures subclass of Loofah::Scrubber
          loofah_fragment.scrub!(scrubber)
        elsif options[:tags] || options[:attributes]
          @permit_scrubber.tags = options[:tags]
          @permit_scrubber.attributes = options[:attributes]
          loofah_fragment.scrub!(@permit_scrubber)
        else
          remove_xpaths(loofah_fragment, XPATHS_TO_REMOVE)
          loofah_fragment.scrub!(:strip)
        end

        loofah_fragment.to_s
      end

      def sanitize_css(style_string)
        Loofah::HTML5::Scrub.scrub_css(style_string)
      end

      class << self
        def bad_tags=(tags)
          allowed_tags.replace(allowed_tags - tags)
        end

        def uri_attributes
          @uri_attributes
        end

        def uri_attributes=(attributes)
          @uri_attributes = attributes
        end

        def update_uri_attributes(new_attributes)
          @uri_attributes.merge new_attributes
        end

        def allowed_attributes
          @allowed_attributes
        end

        def allowed_attributes=(attributes)
          @allowed_attributes = attributes
        end

        def update_allowed_attributes(new_attributes)
          @allowed_attributes.merge new_attributes
        end

        def allowed_tags
          @allowed_tags
        end

        def allowed_tags=(tags)
          @allowed_tags = tags
        end

        def update_allowed_tags(new_tags)
          @allowed_tags.merge new_tags
        end

        def allowed_protocols
          @allowed_protocols
        end

        def allowed_protocols=(protocols)
          @allowed_protocols = protocols
        end

        def update_allowed_protocols(new_protocols)
          @allowed_protocols.merge new_protocols
        end

        def allowed_css_properties
          @allowed_css_properties
        end

        def allowed_css_properties=(css_properties)
          @allowed_css_properties = css_properties
        end

        def update_allowed_css_properties(new_css_properties)
          @allowed_css_properties.merge new_css_properties
        end

        def allowed_css_keywords
          @allowed_css_keywords
        end

        def allowed_css_keywords=(css_keywords)
          @allowed_css_keywords = css_keywords
        end

        def update_allowed_css_keywords(new_css_keywords)
          @allowed_css_keywords.merge new_css_keywords
        end

        def shorthand_css_properties
          @shorthand_css_properties
        end

        def shorthand_css_properties=(css_properties)
          @shorthand_css_properties = css_properties
        end

        def update_shorthand_css_properties(new_css_properties)
          @shorthand_css_properties.merge new_css_properties
        end
      end

      # Constants are from Loofahs source at lib/loofah/html5/whitelist.rb
      self.uri_attributes = Loofah::HTML5::WhiteList::ATTR_VAL_IS_URI

      self.allowed_tags = Loofah::HTML5::WhiteList::ALLOWED_ELEMENTS

      self.bad_tags = Set.new %w(script form)

      self.allowed_attributes = Loofah::HTML5::WhiteList::ALLOWED_ATTRIBUTES

      self.allowed_css_properties = Loofah::HTML5::WhiteList::ALLOWED_CSS_PROPERTIES

      self.allowed_css_keywords = Loofah::HTML5::WhiteList::ALLOWED_CSS_KEYWORDS

      self.shorthand_css_properties = Loofah::HTML5::WhiteList::SHORTHAND_CSS_PROPERTIES

      self.allowed_protocols = Loofah::HTML5::WhiteList::ALLOWED_PROTOCOLS
    end
  end
end
