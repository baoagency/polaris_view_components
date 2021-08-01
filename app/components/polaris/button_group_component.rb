# frozen_string_literal: true

module Polaris
  class ButtonGroupComponent < Polaris::NewComponent
    SPACING_DEFAULT = :default
    SPACING_MAPPINGS = {
      SPACING_DEFAULT => "",
      :extra_tight => "Polaris-ButtonGroup--extraTight",
      :tight => "Polaris-ButtonGroup--tight",
      :loose => "Polaris-ButtonGroup--loose",
    }
    SPACING_OPTIONS = SPACING_MAPPINGS.keys

    renders_many :buttons, ButtonComponent
    renders_many :items

    def initialize(
      connected_top: false,
      full_width: false,
      segmented: false,
      spacing: SPACING_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments
      if connected_top
        @system_arguments["data-buttongroup-connected-top"] = true
      end
      if full_width
        @system_arguments["data-buttongroup-full-width"] = true
      end
      if segmented
        @system_arguments["data-buttongroup-segmented"] = true
      end
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ButtonGroup",
        SPACING_MAPPINGS[fetch_or_fallback(SPACING_OPTIONS, spacing, SPACING_DEFAULT)],
        "Polaris-ButtonGroup--fullWidth": full_width,
        "Polaris-ButtonGroup--segmented": segmented,
      )
    end

    def render?
      buttons.any? || items.any?
    end
  end
end
