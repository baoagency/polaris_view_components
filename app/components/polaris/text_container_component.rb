# frozen_string_literal: true

module Polaris
  class TextContainerComponent < Polaris::Component
    SPACING_DEFAULT = :default
    SPACING_MAPPINGS = {
      SPACING_DEFAULT => "",
      :tight => "Polaris-TextContainer--spacingTight",
      :loose => "Polaris-TextContainer--spacingLoose"
    }
    SPACING_OPTIONS = SPACING_MAPPINGS.keys

    def initialize(
      spacing: SPACING_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-TextContainer",
        SPACING_MAPPINGS[fetch_or_fallback(SPACING_OPTIONS, spacing, SPACING_DEFAULT)]
      )
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
