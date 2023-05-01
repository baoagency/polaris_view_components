# frozen_string_literal: true

module Polaris
  class PageActionsComponent < Polaris::Component
    renders_one :primary_action, ->(primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    renders_many :secondary_actions, Polaris::ButtonComponent

    def initialize(**system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-PageActions"
      )
    end
  end
end
