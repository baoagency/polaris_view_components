# frozen_string_literal: true

module Polaris
  class ShopifyNavigationComponent < Polaris::NewComponent
    renders_many :links, "ShopifyNavigationLinkComponent"

    def initialize(**system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "shp-Navigation",
      )
    end

    def render?
      links.any?
    end

    class ShopifyNavigationLinkComponent < Polaris::NewComponent
      def initialize(url:, active: false, **system_arguments)
        @system_arguments = system_arguments
        @system_arguments[:tag] = "a"
        @system_arguments[:href] = url
        @system_arguments[:role] = "tab"
        @system_arguments["data-polaris-unstyled"] = true
        @system_arguments["aria-selected"] = active
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "shp-Navigation_Link",
        )
      end

      def call
        tag.li(class: "shp-Navigation_Item", role: "presentation") do
          render(Polaris::BaseComponent.new(**@system_arguments)) do
            tag.span(class: "shp-Navigation_LinkText") { content }
          end
        end
      end
    end
  end
end
