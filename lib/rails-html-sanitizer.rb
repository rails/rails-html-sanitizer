# frozen_string_literal: true

require_relative "rails/html/sanitizer/version"

require "loofah"

require_relative "rails/html/scrubbers"
require_relative "rails/html/sanitizer"

module Rails
  Html = HTML # :nodoc:
end

module ActionView
  module Helpers
    module SanitizeHelper
      module ClassMethods
        # Replaces the allowed tags for the +sanitize+ helper.
        #
        #   class Application < Rails::Application
        #     config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td'
        #   end
        #
        def sanitized_allowed_tags=(tags)
          sanitizer_vendor.safe_list_sanitizer.allowed_tags = tags
        end

        # Replaces the allowed HTML attributes for the +sanitize+ helper.
        #
        #   class Application < Rails::Application
        #     config.action_view.sanitized_allowed_attributes = ['onclick', 'longdesc']
        #   end
        #
        def sanitized_allowed_attributes=(attributes)
          sanitizer_vendor.safe_list_sanitizer.allowed_attributes = attributes
        end
      end
    end
  end
end
