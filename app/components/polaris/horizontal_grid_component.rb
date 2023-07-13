module Polaris
  class HorizontalGridComponent < Polaris::Component
    COLUMNS_MAPPINGS = {
      oneThird: "minmax(0, 1fr)",
      oneHalf: "minmax(0, 1fr)",
      twoThirds: "minmax(0, 2fr)"
    }
    COLUMNS_OPTIONS = COLUMNS_MAPPINGS.keys
    ALIGN_OPTIONS = %i[start center end baseline stretch]

    def initialize(
      columns: nil,
      gap: nil,
      align_items: nil,
      **system_arguments
    )
      @system_arguments = system_arguments.tap do |args|
        args[:tag] = "div"
        args[:classes] = class_names(
          args[:classes],
          "Polaris-HorizontalGrid"
        )
        args[:style] = styles_list(
          args[:style],
          "--pc-horizontal-grid-align-items": fetch_or_fallback(ALIGN_OPTIONS, align_items, allow_nil: true),
          **gap_value(gap),
          **columns_value(columns)
        )
      end
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end

    private

    def gap_value(gap)
      return {} unless gap

      value = fetch_or_fallback_nested(
        Tokens::Spacing::SCREEN_SIZES,
        Tokens::Spacing::SCALE,
        gap
      )

      if value.is_a?(Hash)
        value.each_with_object({}) do |(key, value), hash|
          hash["--pc-horizontal-grid-gap-#{key}"] = "var(--p-space-#{value})"
        end
      else
        {"--pc-horizontal-grid-gap-xs": "var(--p-space-#{value})"}
      end
    end

    def columns_value(columns)
      return {} unless columns

      if columns.is_a?(Hash)
        columns.each_with_object({}) do |(key, value), hash|
          hash["--pc-horizontal-grid-grid-template-columns-#{key}"] = column_value(value)
        end
      else
        {"--pc-horizontal-grid-grid-template-columns-xs": column_value(columns)}
      end
    end

    def column_value(value)
      return unless value

      if value.is_a?(Integer)
        "repeat(#{value}, minmax(0, 1fr));"
      elsif value.is_a?(Array)
        value.map do |column|
          COLUMNS_MAPPINGS[fetch_or_fallback(COLUMNS_OPTIONS, column)]
        end.join(" ")
      else
        value
      end
    end
  end
end
