# frozen_string_literal: true

module Polaris
  class PageActionsComponent < Polaris::NewComponent
    DISTRIBUTION_DEFAULT = nil
    DISTRIBUTION_OPTIONS = [
      DISTRIBUTION_DEFAULT,
      :equal_spacing,
      :leading,
      :trailing,
      :center,
      :fill,
      :fill_evenly
    ]

    renders_one :primary_action, ->(primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    renders_many :secondary_actions, Polaris::ButtonComponent

    def initialize(distribution: DISTRIBUTION_DEFAULT, **system_arguments)
      @distribution = fetch_or_fallback(DISTRIBUTION_OPTIONS, distribution, DISTRIBUTION_DEFAULT)
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-PageActions"
      )
    end

    private

    def stack_distribution
      return @distribution if @distribution.present?

      primary_action.present? && secondary_actions.any? ? :equal_spacing : :trailing
    end
  end
end
