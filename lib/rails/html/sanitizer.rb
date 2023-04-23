# frozen_string_literal: true

module Rails
  module Html
    class Sanitizer # :nodoc:
      class << self
        def full_sanitizer
          Rails::Html::FullSanitizer
        end

        def link_sanitizer
          Rails::Html::LinkSanitizer
        end

        def safe_list_sanitizer
          Rails::Html::SafeListSanitizer
        end

        def white_list_sanitizer # :nodoc:
          safe_list_sanitizer
        end
      end

      def sanitize(html, options = {})
        raise NotImplementedError, "subclasses must implement sanitize method."
      end

      private
        def remove_xpaths(node, xpaths)
          node.xpath(*xpaths).remove
          node
        end

        def properly_encode(fragment, options)
          fragment.xml? ? fragment.to_xml(options) : fragment.to_html(options)
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

        loofah_fragment = Loofah.fragment(html)

        loofah_fragment.scrub!(TextOnlyScrubber.new)

        properly_encode(loofah_fragment, encoding: "UTF-8")
      end
    end

    # === Rails::Html::LinkSanitizer
    # Removes +a+ tags and +href+ attributes leaving only the link text.
    #
    #  link_sanitizer = Rails::Html::LinkSanitizer.new
    #  link_sanitizer.sanitize('<a href="example.com">Only the link text will be kept.</a>')
    #
    #  => 'Only the link text will be kept.'
    class LinkSanitizer < Sanitizer
      def initialize
        @link_scrubber = TargetScrubber.new
        @link_scrubber.tags = %w(a)
        @link_scrubber.attributes = %w(href)
      end

      def sanitize(html, options = {})
        Loofah.scrub_fragment(html, @link_scrubber).to_s
      end
    end

    # === Rails::Html::SafeListSanitizer
    # Sanitizes html and css from an extensive safe list (see link further down).
    #
    # === Whitespace
    # We can't make any guarantees about whitespace being kept or stripped.
    # Loofah uses Nokogiri, which wraps either a C or Java parser for the
    # respective Ruby implementation.
    # Those two parsers determine how whitespace is ultimately handled.
    #
    # When the stripped markup will be rendered the users browser won't take
    # whitespace into account anyway. It might be better to suggest your users
    # wrap their whitespace sensitive content in pre tags or that you do
    # so automatically.
    #
    # === Options
    # Sanitizes both html and css via the safe lists found here:
    # https://github.com/flavorjones/loofah/blob/master/lib/loofah/html5/safelist.rb
    #
    # SafeListSanitizer also accepts options to configure
    # the safe list used when sanitizing html.
    # There's a class level option:
    # Rails::Html::SafeListSanitizer.allowed_tags = %w(table tr td)
    # Rails::Html::SafeListSanitizer.allowed_attributes = %w(id class style)
    #
    # Tags and attributes can also be passed to +sanitize+.
    # Passed options take precedence over the class level options.
    #
    # === Examples
    # safe_list_sanitizer = Rails::Html::SafeListSanitizer.new
    #
    # Sanitize css doesn't take options
    # safe_list_sanitizer.sanitize_css('background-color: #000;')
    #
    # Default: sanitize via a extensive safe list of allowed elements
    # safe_list_sanitizer.sanitize(@article.body)
    #
    # Safe list via the supplied tags and attributes
    # safe_list_sanitizer.sanitize(@article.body, tags: %w(table tr td),
    # attributes: %w(id class style))
    #
    # Safe list via a custom scrubber
    # safe_list_sanitizer.sanitize(@article.body, scrubber: ArticleScrubber.new)
    class SafeListSanitizer < Sanitizer
      class << self
        attr_accessor :allowed_tags
        attr_accessor :allowed_attributes
      end
      self.allowed_tags = Set.new([
        "a",
        "abbr",
        "acronym",
        "address",
        "b",
        "big",
        "blockquote",
        "br",
        "cite",
        "code",
        "dd",
        "del",
        "dfn",
        "div",
        "dl",
        "dt",
        "em",
        "h1",
        "h2",
        "h3",
        "h4",
        "h5",
        "h6",
        "hr",
        "i",
        "img",
        "ins",
        "kbd",
        "li",
        "ol",
        "p",
        "pre",
        "samp",
        "small",
        "span",
        "strong",
        "sub",
        "sup",
        "time",
        "tt",
        "ul",
        "var",
      ])
      self.allowed_attributes = Set.new([
        "abbr",
        "alt",
        "cite",
        "class",
        "datetime",
        "height",
        "href",
        "lang",
        "name",
        "src",
        "title",
        "width",
        "xml:lang",
      ])

      def initialize(prune: false)
        @permit_scrubber = PermitScrubber.new(prune: prune)
      end

      def sanitize(html, options = {})
        return unless html
        return html if html.empty?

        loofah_fragment = Loofah.fragment(html)

        if scrubber = options[:scrubber]
          # No duck typing, Loofah ensures subclass of Loofah::Scrubber
          loofah_fragment.scrub!(scrubber)
        elsif allowed_tags(options) || allowed_attributes(options)
          @permit_scrubber.tags = allowed_tags(options)
          @permit_scrubber.attributes = allowed_attributes(options)
          loofah_fragment.scrub!(@permit_scrubber)
        else
          loofah_fragment.scrub!(:strip)
        end

        properly_encode(loofah_fragment, encoding: "UTF-8")
      end

      def sanitize_css(style_string)
        Loofah::HTML5::Scrub.scrub_css(style_string)
      end

      private
        def allowed_tags(options)
          options[:tags] || self.class.allowed_tags
        end

        def allowed_attributes(options)
          options[:attributes] || self.class.allowed_attributes
        end
    end

    WhiteListSanitizer = SafeListSanitizer # :nodoc:
  end
end
