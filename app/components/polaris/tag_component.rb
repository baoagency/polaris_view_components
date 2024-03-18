# frozen_string_literal: true

module Polaris
  class TagComponent < Polaris::Component
    renders_one :remove_button, ->(type: :button, **system_arguments) do
      render Polaris::BaseButton.new(
        classes: "Polaris-Tag__Button",
        disabled: @disabled,
        type: type,
        **system_arguments
      ) do |button|
        polaris_icon(name: "XSmallIcon")
      end
    end

    def initialize(clickable: false, disabled: false, **system_arguments)
      @clickable = clickable
      @disabled = disabled

      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = @clickable ? "button" : "span"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Tag",
          "Polaris-Tag--clickable" => @clickable,
          "Polaris-Tag--disabled" => @disabled,
          "Polaris-Tag--removable" => remove_button.present?
        )
      end
    end
  end
end
