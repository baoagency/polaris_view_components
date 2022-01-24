# frozen_string_literal: true

module Polaris
  class TextStyleComponent < Polaris::Component
    VARIATION_DEFAULT = :default
    VARIATION_MAPPINGS = {
      VARIATION_DEFAULT => "",
      :positive => "Polaris-TextStyle--variationPositive",
      :negative => "Polaris-TextStyle--variationNegative",
      :strong => "Polaris-TextStyle--variationStrong",
      :subdued => "Polaris-TextStyle--variationSubdued",
      :code => "Polaris-TextStyle--variationCode"
    }
    VARIATION_OPTIONS = VARIATION_MAPPINGS.keys

    SIZE_DEFAULT = :default
    SIZE_MAPPINGS = {
      SIZE_DEFAULT => "",
      :small => "Polaris-TextStyle--sizeSmall"
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    def initialize(
      variation: VARIATION_DEFAULT,
      size: SIZE_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = "span"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        VARIATION_MAPPINGS[fetch_or_fallback(VARIATION_OPTIONS, variation, VARIATION_DEFAULT)],
        SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)]
      )
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
