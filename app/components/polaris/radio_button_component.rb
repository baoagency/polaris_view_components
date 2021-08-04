# frozen_string_literal: true

module Polaris
  class RadioButtonComponent < Polaris::NewComponent
    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      label: nil,
      label_hidden: false,
      checked: false,
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
      @value = value

      @system_arguments = system_arguments
      @system_arguments[:tag] = "span"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-RadioButton",
        "Polaris-RadioButton--labelHidden": label_hidden,
      )

      @wrapper_arguments = {
        label: label,
        label_hidden: label_hidden,
        help_text: help_text,
        disabled: disabled,
      }.merge(wrapper_arguments)

      @input_options = input_options
      @input_options[:aria] ||= {}
      @input_options[:disabled] = true if disabled
      @input_options[:aria][:checked] = checked
      @input_options[:class] = class_names(
        @input_options[:classes],
        "Polaris-RadioButton__Input",
      )
    end

    def wrapper_arguments
      @wrapper_arguments[:children_content] = content
      @wrapper_arguments
    end
  end
end
