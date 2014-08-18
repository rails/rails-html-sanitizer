require "rails/html/sanitizer/version"
require "loofah"
require "rails/html/scrubbers"
require "rails/html/sanitizer"

module Rails
  module Html
    class Sanitizer
      class << self
        def full_sanitizer
          Html::FullSanitizer
        end

        def link_sanitizer
          Html::LinkSanitizer
        end

        def white_list_sanitizer
          Html::WhiteListSanitizer
        end
      end
    end
  end
end

module ActionView
  module Helpers
    module SanitizeHelper
      if method_defined?(:sanitizer_vendor) || private_method_defined?(:sanitizer_vendor)
        undef_method(:sanitizer_vendor)
      end

      def sanitizer_vendor
        Rails::Html::Sanitizer
      end
    end
  end
end
