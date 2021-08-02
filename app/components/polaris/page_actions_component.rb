# frozen_string_literal: true

module Polaris
  class PageActionsComponent < Polaris::NewComponent
    renders_one :primary_action, -> (primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    renders_many :secondary_actions, Polaris::ButtonComponent

    def initialize(**system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-PageActions",
      )
    end

    private
      def stack_distribution
        (primary_action.present? && secondary_actions.any?) ? :equal_spacing : :trailing
      end
  end
end
