require "rails/engine"
require "view_component/engine"

module Polaris
  module ViewComponents
    class Engine < ::Rails::Engine
      isolate_namespace Polaris::ViewComponents

      config.autoload_paths = %W[
        #{root}/app/components
        #{root}/app/helpers
      ]

      initializer "polaris_view_components.assets" do |app|
        if app.config.respond_to?(:assets)
          app.config.assets.precompile += %w[
            polaris_view_components.js polaris_view_components.css
          ]
        end
      end

      initializer "polaris_view_components.helpers" do
        ActiveSupport.on_load(:action_controller_base) do
          helper Polaris::ViewHelper
          helper Polaris::UrlHelper
          helper Polaris::ActionHelper
          helper Polaris::ConditionalHelper
        end
      end
    end
  end
end
