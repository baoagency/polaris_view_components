# frozen_string_literal: true

module Polaris
  class CalloutCardComponent < Polaris::Component
    renders_one :primary_action, Polaris::ButtonComponent
    renders_one :secondary_action, ->(plain: true, **system_arguments) do
      Polaris::ButtonComponent.new(plain: plain, **system_arguments)
    end
    renders_one :dismiss_button, ->(**system_arguments) do
      render Polaris::ButtonComponent.new(plain: true, **system_arguments) do |button|
        button.with_icon(name: "XSmallIcon")
      end
    end

    def initialize(
      title: nil,
      illustration: nil,
      **system_arguments
    )
      @title = title
      @illustration = illustration

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-LegacyCard"
      )
    end

    def container_classes
      class_names(
        "Polaris-CalloutCard__Container",
        "Polaris-CalloutCard--hasDismiss": dismiss_button.present?
      )
    end

    def image_classes
      class_names(
        "Polaris-CalloutCard__Image",
        "Polaris-CalloutCard__DismissImage": dismiss_button.present?
      )
    end
  end
end
