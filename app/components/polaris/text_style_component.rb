# frozen_string_literal: true

module Polaris
  class TextStyleComponent < Polaris::NewComponent
    VARIATION_DEFAULT = :default
    VARIATION_MAPPINGS = {
      VARIATION_DEFAULT => "",
      :positive => "Polaris-TextStyle--variationPositive",
      :negative => "Polaris-TextStyle--variationNegative",
      :strong => "Polaris-TextStyle--variationStrong",
      :subdued => "Polaris-TextStyle--variationSubdued",
      :code => "Polaris-TextStyle--variationCode",
    }
    VARIATION_OPTIONS = VARIATION_MAPPINGS.keys

    def initialize(
      variation: VARIATION_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = 'span'
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        VARIATION_MAPPINGS[fetch_or_fallback(VARIATION_OPTIONS, variation, VARIATION_DEFAULT)],
      )
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
