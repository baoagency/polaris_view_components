# frozen_string_literal: true

module Polaris
  class SpinnerComponent < Polaris::NewComponent
    SIZE_DEFAULT = :large
    SIZE_MAPPINGS = {
      small: "Polaris-Spinner--sizeSmall",
      large: "Polaris-Spinner--sizeLarge",
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    def initialize(
      size: SIZE_DEFAULT,
      **system_arguments
    )
      @size = size
      @system_arguments = system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Spinner",
        SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)],
      )
    end
  end
end
