# frozen_string_literal: true

require "rails"
require "rails/html/sanitizer"

module Rails
  module HTML
    class Sanitizer
      class Railtie < Rails::Railtie # :nodoc:
        initializer "rails_html_sanitizer.sanitizer_vendor" do |app|
          ActiveSupport.on_load(:action_view) do
            ActionView::Helpers::SanitizeHelper.sanitizer_vendor = Rails::HTML4::Sanitizer
          end
        end
      end
    end
  end
end
