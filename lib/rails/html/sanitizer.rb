module Rails
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

    # === Rails::Html::FullSanitizer
    # Removes all tags but strips out scripts, forms and comments.
    #
    # full_sanitizer = Rails::Html::FullSanitizer.new
    # full_sanitizer.sanitize("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...")
    # # => Bold no more!  See more here...
    class FullSanitizer < Sanitizer
      def sanitize(html, options = {})
        return unless html
        return html if html.empty?

        Loofah.fragment(html).tap do |fragment|
          remove_xpaths(fragment, XPATHS_TO_REMOVE)
        end.text
      end
    end

    # === Rails::Html::LinkSanitizer
    # Removes a tags and href attributes leaving only the link text
    #
    # link_sanitizer = Rails::Html::LinkSanitizer.new
    # link_sanitizer.sanitize('<a href="example.com">Only the link text will be kept.</a>')
    # # => Only the link text will be kept.
    class LinkSanitizer < Sanitizer
      def initialize
        @link_scrubber = TargetScrubber.new
        @link_scrubber.tags = %w(a href)
        @link_scrubber.attributes = %w(href)
      end

      def sanitize(html, options = {})
        Loofah.scrub_fragment(html, @link_scrubber).to_s
      end
    end

    # === Rails::Html::WhiteListSanitizer
    # Sanitizes both html and css via the white lists found here:
    # https://github.com/flavorjones/loofah/blob/master/lib/loofah/html5/whitelist.rb
    #
    # However, WhiteListSanitizer also accepts options to configure
    # the white list used when sanitizing html.
    #
    # === Examples
    # white_list_sanitizer = Rails::Html::WhiteListSanitizer.new
    #
    # Sanitize css doesn't take options
    # white_list_sanitizer.sanitize_css('background-color: #000;')
    #
    # Default: sanitize via a extensive white list of allowed elements
    # white_list_sanitizer.sanitize(@article.body)
    #
    # White list via the supplied tags and attributes
    # white_list_sanitizer.sanitize(@article.body, tags: %w(table tr td),
    # attributes: %w(id class style))
    #
    # White list via a custom scrubber
    # white_list_sanitizer.sanitize(@article.body, scrubber: ArticleScrubber.new)
    class WhiteListSanitizer < Sanitizer
      def sanitize(html, options = {})
        return unless html
        return html if html.empty?

        loofah_fragment = Loofah.fragment(html)

        if scrubber = options[:scrubber]
          # No duck typing, Loofah ensures subclass of Loofah::Scrubber
          loofah_fragment.scrub!(scrubber)
        elsif options[:tags] || options[:attributes]
          self.class.tags = options[:tags]
          self.class.attributes = options[:attributes]
          loofah_fragment.scrub!(permit_scrubber)
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
        def tags
          permit_scrubber.tags
        end

        def tags=(tags)
          permit_scrubber.tags = tags
        end

        def attributes
          permit_scrubber.attributes
        end

        def attributes=(attributes)
          permit_scrubber.attributes = attributes
        end
      end

      private
        def self.permit_scrubber
          @permit_scrubber ||= PermitScrubber.new
        end

        def permit_scrubber
          self.class.permit_scrubber
        end
    end
  end
end
