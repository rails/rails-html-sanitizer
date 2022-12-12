module Rails
  module Html
    # === Rails::Html::PermitScrubber
    #
    # +Rails::Html::PermitScrubber+ allows you to permit only your own tags and/or attributes.
    #
    # +Rails::Html::PermitScrubber+ can be subclassed to determine:
    # - When a node should be skipped via +skip_node?+.
    # - When a node is allowed via +allowed_node?+.
    # - When an attribute should be scrubbed via +scrub_attribute?+.
    #
    # Subclasses don't need to worry if tags or attributes are set or not.
    # If tags or attributes are not set, Loofah's behavior will be used.
    # If you override +allowed_node?+ and no tags are set, it will not be called.
    # Instead Loofahs behavior will be used.
    # Likewise for +scrub_attribute?+ and attributes respectively.
    #
    # Text and CDATA nodes are skipped by default.
    # Unallowed elements will be stripped, i.e. element is removed but its subtree kept.
    # Supplied tags and attributes should be Enumerables.
    #
    # +tags=+
    # If set, elements excluded will be stripped.
    # If not, elements are stripped based on Loofahs +HTML5::Scrub.allowed_element?+.
    #
    # +attributes=+
    # If set, attributes excluded will be removed.
    # If not, attributes are removed based on Loofahs +HTML5::Scrub.scrub_attributes+.
    #
    #  class CommentScrubber < Html::PermitScrubber
    #    def initialize
    #      super
    #      self.tags = %w(form script comment blockquote)
    #    end
    #
    #    def skip_node?(node)
    #      node.text?
    #    end
    #
    #    def scrub_attribute?(name)
    #      name == "style"
    #    end
    #  end
    #
    # See the documentation for +Nokogiri::XML::Node+ to understand what's possible
    # with nodes: https://nokogiri.org/rdoc/Nokogiri/XML/Node.html
    class PermitScrubber < Loofah::Scrubber
      attr_reader :tags, :attributes, :prune

      def initialize(prune: false)
        @prune = prune
        @direction = @prune ? :top_down : :bottom_up
        @tags, @attributes = nil, nil
      end

      def tags=(tags)
        @tags = validate!(tags, :tags)
      end

      def attributes=(attributes)
        @attributes = validate!(attributes, :attributes)
      end

      def scrub(node)
        if node.cdata?
          text = node.document.create_text_node node.text
          node.replace text
          return CONTINUE
        end
        return CONTINUE if skip_node?(node)

        unless (node.element? || node.comment?) && keep_node?(node)
          return STOP if scrub_node(node) == STOP
        end

        scrub_attributes(node)
      end

      protected

      def allowed_node?(node)
        @tags.include?(node.name)
      end

      def skip_node?(node)
        node.text?
      end

      def keep_node?(node)
        if @tags
          allowed_node?(node)
        else
          Loofah::HTML5::Scrub.allowed_element?(node.name)
        end
      end

      def scrub_node(node)
        node.before(node.children) unless prune # strip
        node.remove
      end

      def scrub_attributes(node)
        if @attributes
          Loofah::HTML5::Scrub.scrub_attributes(node, allowed_attribute_names: @attributes)
        else
          Loofah::HTML5::Scrub.scrub_attributes(node)
        end
      end

      def validate!(var, name)
        if var && !var.is_a?(Enumerable)
          raise ArgumentError, "You should pass :#{name} as an Enumerable"
        end
        var
      end
    end

    # === Rails::Html::TargetScrubber
    #
    # Where +Rails::Html::PermitScrubber+ picks out tags and attributes to permit in
    # sanitization, +Rails::Html::TargetScrubber+ targets them for removal.
    #
    # +tags=+
    # If set, elements included will be stripped.
    #
    # +attributes=+
    # If set, attributes included will be removed.
    class TargetScrubber < PermitScrubber
      def allowed_node?(node)
        !super
      end

      def scrub_attribute?(name)
        !super
      end
    end

    # === Rails::Html::TextOnlyScrubber
    #
    # +Rails::Html::TextOnlyScrubber+ allows you to permit text nodes.
    #
    # Unallowed elements will be stripped, i.e. element is removed but its subtree kept.
    class TextOnlyScrubber < Loofah::Scrubber
      def initialize
        @direction = :bottom_up
      end

      def scrub(node)
        if node.text?
          CONTINUE
        else
          node.before node.children
          node.remove
        end
      end
    end
  end
end
