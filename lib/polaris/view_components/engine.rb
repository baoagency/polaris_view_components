require "rails/engine"
require "view_component/engine"

module Polaris
  module ViewComponents
    class Engine < ::Rails::Engine
      isolate_namespace Polaris::ViewComponents

      config.autoload_paths = %W[
        #{root}/app/components
        #{root}/app/lib
      ]

      initializer "polaris_view_components.assets.precompile" do |app|
        if app.config.respond_to?(:assets)
          app.config.assets.precompile += %w[polaris_view_components.css]
        end
      end
    end
  end
end
