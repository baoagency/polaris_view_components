# frozen_string_literal: true

module Polaris
  class ModalComponent < Polaris::Component
    renders_one :close_button, ->(**system_arguments) do
      button_arguments = @close_button_arguments.deep_merge(system_arguments)
      render(Polaris::BaseComponent.new(**button_arguments)) do
        polaris_icon(name: "XIcon", color: :base)
      end
    end
    renders_many :sections, Polaris::Modal::SectionComponent
    renders_one :primary_action, ->(primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    renders_many :secondary_actions, Polaris::ButtonComponent

    def initialize(
      title:,
      open: false,
      sectioned: true,
      scrollable: true,
      large: false,
      small: false,
      limit_height: false,
      dialog_arguments: {},
      **system_arguments
    )
      @title = title
      @open = open
      @sectioned = sectioned
      @scrollable = scrollable
      @large = large
      @small = small
      @limit_height = limit_height
      @dialog_arguments = dialog_arguments
      @system_arguments = system_arguments
      @close_button_arguments = {
        tag: "button",
        type: "button",
        classes: "Polaris-Modal-CloseButton",
        aria: {label: "Close"}
      }
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] ||= {}
        prepend_option(opts[:data], :controller, "polaris-modal")
        opts[:data][:polaris_modal_open_value] = @open
        opts[:data][:polaris_modal_hidden_class] = "Polaris--hidden"
        opts[:data][:polaris_modal_backdrop_class] = "Polaris-Backdrop"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Modal-Dialog__Container",
          "Polaris--hidden"
        )
      end
    end

    def dialog_arguments
      @dialog_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:role] = "dialog"
        opts[:aria] ||= {}
        opts[:aria][:modal] = "true"
        opts[:tabindex] = "-1"
        opts[:classes] = class_names(
          @dialog_arguments[:classes],
          "Polaris-Modal-Dialog"
        )
      end
    end

    def close_button_arguments
      @close_button_arguments.deep_merge({
        data: {action: "polaris-modal#close"}
      })
    end

    def modal_classes
      class_names(
        "Polaris-Modal-Dialog__Modal",
        "Polaris-Modal-Dialog--sizeLarge": @large,
        "Polaris-Modal-Dialog--sizeSmall": @small,
        "Polaris-Modal-Dialog--limitHeight": @limit_height
      )
    end

    def render_footer?
      primary_action.present? || secondary_actions.any?
    end
  end
end
