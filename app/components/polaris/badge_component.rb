# frozen_string_literal: true

module Polaris
  class BadgeComponent < Polaris::NewComponent
    PROGRESS_DEFAULT = :default
    PROGRESS_MAPPINGS = {
      PROGRESS_DEFAULT => "",
      :incomplete => "Polaris-Badge--progressIncomplete",
      :partially_complete => "Polaris-Badge--progressPartiallyComplete",
      :complete => "Polaris-Badge--progressComplete"
    }
    PROGRESS_OPTIONS = PROGRESS_MAPPINGS.keys

    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      SIZE_DEFAULT => "",
      :small => "Polaris-Badge--sizeSmall"
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    STATUS_DEFAULT = :default
    STATUS_MAPPINGS = {
      STATUS_DEFAULT => "",
      :success => "Polaris-Badge--statusSuccess",
      :info => "Polaris-Badge--statusInfo",
      :attention => "Polaris-Badge--statusAttention",
      :critical => "Polaris-Badge--statusCritical",
      :warning => "Polaris-Badge--statusWarning",
      :new => "Polaris-Badge--statusNew"
    }
    STATUS_OPTIONS = STATUS_MAPPINGS.keys

    def initialize(
      progress: PROGRESS_DEFAULT,
      size: SIZE_DEFAULT,
      status: STATUS_DEFAULT,
      **system_arguments
    )
      @progress = progress

      @system_arguments = system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Badge",
        PROGRESS_MAPPINGS[fetch_or_fallback(PROGRESS_OPTIONS, progress, PROGRESS_DEFAULT)],
        SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)],
        STATUS_MAPPINGS[fetch_or_fallback(STATUS_OPTIONS, status, STATUS_DEFAULT)],
      )
    end
  end
end
