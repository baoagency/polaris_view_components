# frozen_string_literal: true

module Polaris
  class EmptyStateComponent < Polaris::Component
    WITHIN_DEFAULT = :page
    WITHIN_OPTIONS = [:page, :container]

    renders_one :primary_action, ->(primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    renders_one :secondary_action, Polaris::ButtonComponent
    renders_one :footer
    renders_one :unsectioned_content

    def initialize(
      image:,
      heading: nil,
      image_contained: false,
      full_width: false,
      within: WITHIN_DEFAULT,
      **system_arguments
    )
      @image = image
      @image_contained_class = image_contained ? "Polaris-EmptyState--imageContained" : nil
      @heading = heading
      @full_width = full_width
      @within = within
      @system_arguments = system_arguments
    end
  end
end
