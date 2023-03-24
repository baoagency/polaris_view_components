# frozen_string_literal: true

module Polaris
  class DividerComponent < Polaris::Component
    BORDER_STYLE_DEFAULT = :divider
    BORDER_STYLE_MAPPINGS = {
      base: "base",
      dark: "dark",
      divider: "divider",
      divider_on_dark: "divider-on-dark",
      transparent: "transparent"
    }
    BORDER_STYLE_OPTIONS = BORDER_STYLE_MAPPINGS.keys

    def initialize(
      border_style: BORDER_STYLE_DEFAULT,
      **system_arguments
    )
      @border_style = BORDER_STYLE_MAPPINGS[fetch_or_fallback(BORDER_STYLE_OPTIONS, border_style, BORDER_STYLE_DEFAULT)]
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "hr"
        opts[:classes] = class_names(
          opts[:classes],
          "Polaris-Divider"
        )
        opts[:style] = "--pc-divider-border-style:var(--p-border-#{@border_style})"
      end
    end

    def call
      render(Polaris::BaseComponent.new(**system_arguments)) { content }
    end
  end
end
