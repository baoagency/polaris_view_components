# frozen_string_literal: true

module Polaris
  class ResourceItemComponent < Polaris::NewComponent
    CURSOR_DEFAULT = :default
    CURSOR_OPTIONS = %i[default pointer]

    ALIGNMENT_DEFAULT = :default
    ALIGNMENT_MAPPINGS = {
      ALIGNMENT_DEFAULT => "",
      center: "Polaris-ResourceItem--alignmentCenter",
    }
    ALIGNMENT_OPTIONS = ALIGNMENT_MAPPINGS.keys

    renders_one :media

    def initialize(
      url: nil,
      cursor: CURSOR_DEFAULT,
      vertical_alignment: ALIGNMENT_DEFAULT,
      **system_arguments
    )
      @url = url
      @cursor = fetch_or_fallback(CURSOR_OPTIONS, cursor, CURSOR_DEFAULT)

      @system_arguments = system_arguments
      @system_arguments[:tag] = "li"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ResourceItem__ListItem",
      )

      @container_arguments = {
        tag: "div",
        classes: class_names(
          "Polaris-ResourceItem__Container",
          ALIGNMENT_MAPPINGS[fetch_or_fallback(ALIGNMENT_OPTIONS, vertical_alignment, ALIGNMENT_DEFAULT)],
        )
      }
    end
  end
end
