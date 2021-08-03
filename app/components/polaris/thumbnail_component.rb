# frozen_string_literal: true

module Polaris
  class ThumbnailComponent < Polaris::NewComponent
    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      small: "Polaris-Thumbnail--sizeSmall",
      medium: "Polaris-Thumbnail--sizeMedium",
      large: "Polaris-Thumbnail--sizeLarge",
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    renders_one :icon, Polaris::IconComponent

    def initialize(
      source: nil,
      size: SIZE_DEFAULT,
      alt: nil,
      **system_arguments
    )
      @source = source
      @alt = alt

      @system_arguments = system_arguments
      @system_arguments[:tag] = "span"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Thumbnail",
        SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)],
      )
    end

    def renders?
      source.present? || icon.present?
    end
  end
end
