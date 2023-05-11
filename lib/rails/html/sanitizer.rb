# frozen_string_literal: true

module Rails
  module Html
    class Sanitizer
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

    module Concern # :nodoc:
      module ComposedSanitize # :nodoc:
        def sanitize(html, options = {})
          return unless html
          return html if html.empty?

          serialize(scrub(parse_fragment(html), options))
        end
      end

      module Parser # :nodoc:
        module Html4 # :nodoc:
          def parse_fragment(html)
            Loofah.html4_fragment(html)
          end
        end
      end

      module Scrubber # :nodoc:
        module Full # :nodoc:
          def scrub(fragment, options = {})
            fragment.scrub!(TextOnlyScrubber.new)
          end
        end

        module Link # :nodoc:
          def initialize
            super
            @link_scrubber = TargetScrubber.new
            @link_scrubber.tags = %w(a)
            @link_scrubber.attributes = %w(href)
          end

          def scrub(fragment, options = {})
            fragment.scrub!(@link_scrubber)
          end
        end

        module SafeList # :nodoc:
          DEFAULT_ALLOWED_TAGS = Set.new([
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
                                         ]).freeze
          DEFAULT_ALLOWED_ATTRIBUTES = Set.new([
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
                                               ]).freeze

          def self.included(klass)
            class << klass
              attr_accessor :allowed_tags
              attr_accessor :allowed_attributes
            end

            klass.allowed_tags = DEFAULT_ALLOWED_TAGS.dup
            klass.allowed_attributes = DEFAULT_ALLOWED_ATTRIBUTES.dup
          end

          def initialize(prune: false)
            @permit_scrubber = PermitScrubber.new(prune: prune)
          end

          def scrub(fragment, options = {})
            if scrubber = options[:scrubber]
              # No duck typing, Loofah ensures subclass of Loofah::Scrubber
              fragment.scrub!(scrubber)
            elsif allowed_tags(options) || allowed_attributes(options)
              @permit_scrubber.tags = allowed_tags(options)
              @permit_scrubber.attributes = allowed_attributes(options)
              fragment.scrub!(@permit_scrubber)
            else
              fragment.scrub!(:strip)
            end
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
      end

      module Serializer # :nodoc:
        module UTF8Encode # :nodoc:
          def serialize(fragment)
            properly_encode(fragment, encoding: "UTF-8")
          end
        end

        module SimpleString # :nodoc:
          def serialize(fragment)
            fragment.to_s
          end
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
      include Concern::ComposedSanitize
      include Concern::Parser::Html4
      include Concern::Scrubber::Full
      include Concern::Serializer::UTF8Encode
    end

    # === Rails::Html::LinkSanitizer
    # Removes +a+ tags and +href+ attributes leaving only the link text.
    #
    #  link_sanitizer = Rails::Html::LinkSanitizer.new
    #  link_sanitizer.sanitize('<a href="example.com">Only the link text will be kept.</a>')
    #
    #  => 'Only the link text will be kept.'
    class LinkSanitizer < Sanitizer
      include Concern::ComposedSanitize
      include Concern::Parser::Html4
      include Concern::Scrubber::Link
      include Concern::Serializer::SimpleString
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
      include Concern::ComposedSanitize
      include Concern::Parser::Html4
      include Concern::Scrubber::SafeList
      include Concern::Serializer::UTF8Encode
    end

    WhiteListSanitizer = SafeListSanitizer # :nodoc:
  end
end
