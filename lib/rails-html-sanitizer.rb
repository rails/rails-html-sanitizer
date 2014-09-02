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
      module ClassMethods
        if method_defined?(:sanitizer_vendor) || private_method_defined?(:sanitizer_vendor)
          undef_method(:sanitizer_vendor)
        end

        def sanitizer_vendor
          Rails::Html::Sanitizer
        end

        if method_defined?(:sanitized_allowed_tags=) || private_method_defined?(:sanitized_allowed_tags=)
          undef_method(:sanitized_allowed_tags=)
        end

        # Replaces the allowed tags for the +sanitize+ helper.
        #
        #   class Application < Rails::Application
        #     config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td'
        #   end
        #
        def sanitized_allowed_tags=(tags)
          sanitizer_vendor.white_list_sanitizer.allowed_tags = tags
        end

        if method_defined?(:sanitized_allowed_attributes=) || private_method_defined?(:sanitized_allowed_attributes=)
          undef_method(:sanitized_allowed_attributes=)
        end

        # Replaces the allowed HTML attributes for the +sanitize+ helper.
        #
        #   class Application < Rails::Application
        #     config.action_view.sanitized_allowed_attributes = ['onclick', 'longdesc']
        #   end
        #
        def sanitized_allowed_attributes=(attributes)
          sanitizer_vendor.white_list_sanitizer.allowed_attributes = attributes
        end
      end
    end
  end
end
