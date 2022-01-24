# frozen_string_literal: true

module Polaris
  class SpacerComponent < Polaris::Component
    VERTICAL_SPACING_DEFAULT = :default
    VERTICAL_SPACING_MAPPINGS = {
      VERTICAL_SPACING_DEFAULT => "",
      :extra_tight => "Polaris-Spacer--verticalSpacingExtraTight",
      :tight => "Polaris-Spacer--verticalSpacingTight",
      :base_tight => "Polaris-Spacer--verticalSpacingBaseTight",
      :base => "Polaris-Spacer--verticalSpacingBase",
      :loose => "Polaris-Spacer--verticalSpacingLoose",
      :extra_loose => "Polaris-Spacer--verticalSpacingExtraLoose"
    }
    VERTICAL_SPACING_OPTIONS = VERTICAL_SPACING_MAPPINGS.keys

    HORIZONTAL_SPACING_DEFAULT = :default
    HORIZONTAL_SPACING_MAPPINGS = {
      HORIZONTAL_SPACING_DEFAULT => "",
      :extra_tight => "Polaris-Spacer--horizontalSpacingExtraTight",
      :tight => "Polaris-Spacer--horizontalSpacingTight",
      :base_tight => "Polaris-Spacer--horizontalSpacingBaseTight",
      :base => "Polaris-Spacer--horizontalSpacingBase",
      :loose => "Polaris-Spacer--horizontalSpacingLoose",
      :extra_loose => "Polaris-Spacer--horizontalSpacingExtraLoose"
    }
    HORIZONTAL_SPACING_OPTIONS = HORIZONTAL_SPACING_MAPPINGS.keys

    def initialize(
      vertical: VERTICAL_SPACING_DEFAULT,
      horizontal: HORIZONTAL_SPACING_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Spacer",
        VERTICAL_SPACING_MAPPINGS[fetch_or_fallback(VERTICAL_SPACING_OPTIONS, vertical, VERTICAL_SPACING_DEFAULT)],
        HORIZONTAL_SPACING_MAPPINGS[fetch_or_fallback(HORIZONTAL_SPACING_OPTIONS, horizontal, HORIZONTAL_SPACING_DEFAULT)]
      )
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) do
        content
      end
    end
  end
end
