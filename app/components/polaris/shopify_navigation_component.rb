# frozen_string_literal: true

module Polaris
  class ShopifyNavigationComponent < Polaris::Component
    renders_many :links, ->(**system_arguments) do
      ShopifyNavigationLinkComponent.new(auto_detect_active: @auto_detect_active, **system_arguments)
    end

    def initialize(auto_detect_active: false, **system_arguments)
      @auto_detect_active = auto_detect_active

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "shp-Navigation"
      )
    end

    def render?
      links.any?
    end

    class ShopifyNavigationLinkComponent < Polaris::Component
      def initialize(url:, auto_detect_active:, active: false, **system_arguments)
        @url = url
        @auto_detect_active = auto_detect_active
        @active = active
        @system_arguments = system_arguments
      end

      def call
        tag.li(class: "shp-Navigation_Item", role: "presentation") do
          render(Polaris::BaseComponent.new(**system_arguments)) do
            tag.span(class: "shp-Navigation_LinkText") { content }
          end
        end
      end

      def system_arguments
        {
          tag: "a",
          href: @url,
          role: "tab",
          data: {polaris_unstyled: true},
          aria: {}
        }.deep_merge(@system_arguments).tap do |args|
          args[:aria][:selected] = @active || detect_active(@url)
          args[:classes] = class_names(
            args[:classes],
            "shp-Navigation_Link"
          )
        end
      end

      def detect_active(url)
        return unless @auto_detect_active

        request.path.include?(url.split("?").first)
      end
    end
  end
end
