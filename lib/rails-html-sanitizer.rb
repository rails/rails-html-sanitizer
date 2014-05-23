require "rails/html/sanitizer/version"
require "loofah"
require "rails/html/scrubbers"
require "rails/html/sanitizer"

module Rails
  module Html
    module Sanitizer
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
