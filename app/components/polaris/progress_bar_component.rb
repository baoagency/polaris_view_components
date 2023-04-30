# frozen_string_literal: true

module Polaris
  class ProgressBarComponent < Polaris::Component
    COLOR_DEFAULT = :highlight
    COLOR_MAPPINGS = {
      COLOR_DEFAULT => "Polaris-ProgressBar--colorHighlight",
      :primary => "Polaris-ProgressBar--colorPrimary",
      :success => "Polaris-ProgressBar--colorSuccess",
      :critical => "Polaris-ProgressBar--colorCritical"
    }
    COLOR_OPTIONS = COLOR_MAPPINGS.keys

    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      SIZE_DEFAULT => "Polaris-ProgressBar--sizeMedium",
      :small => "Polaris-ProgressBar--sizeSmall",
      :large => "Polaris-ProgressBar--sizeLarge"
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    def initialize(
      animated: true,
      color: COLOR_DEFAULT,
      progress: 0,
      size: SIZE_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = :div
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ProgressBar",
        COLOR_MAPPINGS[fetch_or_fallback(COLOR_OPTIONS, color, COLOR_DEFAULT)],
        SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)]
      )

      @animated = animated
      @progress = progress
    end

    def progress_arguments
      {tag: "div"}.tap do |args|
        args[:classes] = class_names(
          "Polaris-ProgressBar__Indicator",
          "Polaris-ProgressBar__IndicatorAppearDone"
        )
        args[:style] = styles_list(
          "--pc-progress-bar-duration": @animated ? "500ms" : "0ms",
          "--pc-progress-bar-percent": @progress / 100.0
        )
      end
    end
  end
end
