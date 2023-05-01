module Polaris
  class HorizontalStackComponent < Polaris::Component
    ALIGN_DEFAULT = :default
    ALIGN_MAPPINGS = {
      default: "",
      start: "start",
      center: "center",
      end: "end",
      space_around: "space-around",
      space_between: "space-between",
      space_evenly: "space-evenly"
    }
    ALIGN_OPTIONS = ALIGN_MAPPINGS.keys

    BLOCK_ALIGN_OPTIONS = %i[start center end baseline stretch]

    def initialize(
      align: ALIGN_DEFAULT,
      block_align: nil,
      gap: nil,
      wrap: true,
      **system_arguments
    )
      @system_arguments = system_arguments.tap do |args|
        args[:tag] = "div"
        args[:classes] = class_names(
          args[:classes],
          "Polaris-HorizontalStack"
        )
        args[:style] = styles_list(
          args[:style],
          "--pc-horizontal-stack-align": ALIGN_MAPPINGS[fetch_or_fallback(ALIGN_OPTIONS, align, ALIGN_DEFAULT)],
          "--pc-horizontal-stack-block-align": fetch_or_fallback(BLOCK_ALIGN_OPTIONS, block_align, allow_nil: true),
          "--pc-horizontal-stack-wrap": wrap ? "wrap" : "nowrap",
          **gap_value(gap)
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
          hash["--pc-horizontal-stack-gap-#{key}"] = "var(--p-space-#{value})"
        end
      else
        {"--pc-horizontal-stack-gap-xs": "var(--p-space-#{value})"}
      end
    end
  end
end
