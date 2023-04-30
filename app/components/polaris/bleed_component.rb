module Polaris
  class BleedComponent < Polaris::Component
    def initialize(
      margin_inline: nil,
      margin_block: nil,
      margin_block_start: nil,
      margin_block_end: nil,
      margin_inline_start: nil,
      margin_inline_end: nil,
      **system_arguments
    )
      @direction_values = {
        margin_inline: margin_inline,
        margin_block: margin_block,
        margin_block_start: margin_block_start,
        margin_block_end: margin_block_end,
        margin_inline_start: margin_inline_start,
        margin_inline_end: margin_inline_end
      }
      @system_arguments = system_arguments.tap do |args|
        args[:tag] = "div"
        args[:classes] = class_names(
          args[:classes],
          "Polaris-Bleed"
        )
        args[:style] = styles_list(
          args[:style],
          **margin_value("margin-block-start", negative_margin(:margin_block_start)),
          **margin_value("margin-block-end", negative_margin(:margin_block_end)),
          **margin_value("margin-inline-start", negative_margin(:margin_inline_start)),
          **margin_value("margin-inline-end", negative_margin(:margin_inline_end))
        )
      end
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end

    private

    def negative_margin(direction)
      x_axis = %i[margin_inline_start margin_inline_end]
      y_axis = %i[margin_block_start margin_block_end]

      if @direction_values[direction]
        @direction_values[direction]
      elsif x_axis.include?(direction) && @direction_values[:margin_inline]
        @direction_values[:margin_inline]
      elsif y_axis.include?(direction) && @direction_values[:margin_block]
        @direction_values[:margin_block]
      end
    end

    def margin_value(property, margin)
      return {} unless margin

      value = fetch_or_fallback_nested(
        Tokens::Spacing::SCREEN_SIZES,
        Tokens::Spacing::SCALE,
        margin
      )

      if value.is_a?(Hash)
        value.each_with_object({}) do |(key, value), hash|
          hash["--pc-bleed-#{property}-#{key}"] = "var(--p-space-#{value})"
        end
      else
        {"--pc-bleed-#{property}-xs": "var(--p-space-#{value})"}
      end
    end
  end
end
