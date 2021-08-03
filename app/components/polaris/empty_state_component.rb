# frozen_string_literal: true

module Polaris
  class EmptyStateComponent < Polaris::NewComponent
    WITHIN_DEFAULT = :page
    WITHIN_MAPPINGS = {
      WITHIN_DEFAULT => "",
      container: "Polaris-EmptyState--withinContentContainer",
    }
    WITHIN_OPTIONS = WITHIN_MAPPINGS.keys

    renders_one :primary_action, -> (primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    renders_one :secondary_action, Polaris::ButtonComponent
    renders_one :footer

    def initialize(
      image:,
      heading: nil,
      full_width: false,
      within: WITHIN_DEFAULT,
      **system_arguments
    )
      @image = image
      @heading = heading

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-EmptyState",
        WITHIN_MAPPINGS[fetch_or_fallback(WITHIN_OPTIONS, within, WITHIN_DEFAULT)],
        "Polaris-EmptyState--fullWidth": full_width,
      )
    end
  end
end
