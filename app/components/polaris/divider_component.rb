# frozen_string_literal: true

module Polaris
  class DividerComponent < Polaris::Component
    def initialize(
      border_color: "border-subdued",
      border_width: "1",
      **system_arguments
    )
      @system_arguments = system_arguments.tap do |args|
        args[:tag] = "hr"
        args[:classes] = class_names(
          args[:classes],
          "Polaris-Divider"
        )
        args[:style] = styles_list(
          args[:style],
          "border-block-start": "var(--p-border-width-#{fetch_or_fallback(Tokens::Border::WIDTH_SCALE, border_width)}) solid #{border_color_value(border_color)}"
        )
      end
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end

    private

    def border_color_value(border_color)
      return "border-subdued" unless border_color
      return "transparent" if border_color == "transparent"
      "var(--p-color-#{fetch_or_fallback(Tokens::Color::BORDER_ALIAS, border_color)})"
    end
  end
end
