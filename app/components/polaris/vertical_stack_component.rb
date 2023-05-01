module Polaris
  class VerticalStackComponent < Polaris::Component
    AS_DEFAULT = :div
    AS_OPTIONS = %i[div ul ol fieldset]

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

    INLINE_ALIGN_OPTIONS = %i[start center end baseline stretch]

    def initialize(
      as: AS_DEFAULT,
      align: ALIGN_DEFAULT,
      inline_align: nil,
      gap: nil,
      reverse_order: false,
      **system_arguments
    )
      @system_arguments = system_arguments.tap do |args|
        args[:tag] = fetch_or_fallback(AS_OPTIONS, as, AS_DEFAULT)
        args[:classes] = class_names(
          args[:classes],
          "Polaris-VerticalStack",
          "Polaris-VerticalStack--listReset": as.in?(%i[ul ol]),
          "Polaris-VerticalStack--fieldsetReset": as == :fieldset
        )
        args[:style] = styles_list(
          args[:style],
          "--pc-vertical-stack-align": ALIGN_MAPPINGS[fetch_or_fallback(ALIGN_OPTIONS, align, ALIGN_DEFAULT)],
          "--pc-vertical-stack-inline-align": fetch_or_fallback(INLINE_ALIGN_OPTIONS, inline_align, allow_nil: true),
          "--pc-vertical-stack-order": reverse_order ? "column-reverse" : "column",
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
          hash["--pc-vertical-stack-gap-#{key}"] = "var(--p-space-#{value})"
        end
      else
        {"--pc-vertical-stack-gap-xs": "var(--p-space-#{value})"}
      end
    end
  end
end
