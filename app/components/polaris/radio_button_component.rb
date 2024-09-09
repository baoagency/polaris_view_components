# frozen_string_literal: true

module Polaris
  class RadioButtonComponent < Polaris::Component
    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      label: nil,
      label_hidden: false,
      checked: nil,
      disabled: false,
      help_text: nil,
      value: nil,
      wrapper_arguments: {},
      input_options: {},
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @checked = checked
      @disabled = disabled
      @value = value

      @system_arguments = system_arguments
      @system_arguments[:tag] = "span"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-RadioButton",
        "Polaris-RadioButton--labelHidden": label_hidden
      )

      @wrapper_arguments = {
        label: label,
        label_hidden: label_hidden,
        help_text: help_text,
        disabled: disabled
      }.merge(wrapper_arguments)

      @input_options = input_options
      @input_options[:classes] = class_names(
        @input_options[:classes],
        "Polaris-RadioButton__Input"
      )
    end

    def wrapper_arguments
      @wrapper_arguments[:children_content] = content
      @wrapper_arguments
    end

    def radio_button
      render Polaris::BaseRadioButton.new(
        form: @form,
        attribute: @attribute,
        name: @name,
        checked: @checked,
        disabled: @disabled,
        value: @value,
        **@input_options
      )
    end
  end
end
