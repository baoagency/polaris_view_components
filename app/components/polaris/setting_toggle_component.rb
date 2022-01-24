# frozen_string_literal: true

module Polaris
  class SettingToggleComponent < Polaris::Component
    renders_one :action, ->(**system_arguments) do
      Polaris::ButtonComponent.new(primary: !@enabled, **system_arguments)
    end

    def initialize(enabled: false, **system_arguments)
      @enabled = enabled
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-SettingAction"
        )
      end
    end
  end
end
