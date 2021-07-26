require "rails/engine"
require "view_component/engine"

module Polaris
  module ViewComponents
    class Engine < ::Rails::Engine
      isolate_namespace Polaris::ViewComponents
      config.autoload_once_paths = %W[
        #{root}/app/components
        #{root}/app/lib
      ]
    end
  end
end
