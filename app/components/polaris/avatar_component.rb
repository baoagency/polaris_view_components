# frozen_string_literal: true

module Polaris
  class AvatarComponent < Polaris::NewComponent
    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      small: "Polaris-Avatar--sizeSmall",
      medium: "Polaris-Avatar--sizeMedium",
      large: "Polaris-Avatar--sizeLarge",
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    def initialize(
      customer: false,
      initials: nil,
      name: nil,
      size: SIZE_DEFAULT,
      source: nil,
      **system_arguments
    )
      @initials = initials
      @source = source

      @system_arguments = system_arguments
      if name
        @system_arguments[:aria] ||= {}
        @system_arguments[:aria][:label] ||= name
      end
      @system_arguments[:role] = "img"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Avatar",
        SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)],
        "Polaris-Avatar--styleOne" => !customer,
        "Polaris-Avatar--hasImage" => source.present?
      )
    end
  end
end
