# frozen_string_literal: true

module Polaris
  class CheckboxComponent < Polaris::NewComponent
    include ActiveModel::Validations

    attr_reader :checked

    validates :checked, inclusion: { in: [true, false, :indeterminate] }

    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      label: nil,
      label_hidden: false,
      checked: false,
      disabled: false,
      help_text: nil,
      error: nil,
      checked_value: "1",
      unchecked_value: "0",
      wrapper_arguments: {},
      input_options: {},
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @checked = checked
      @checked_value = checked_value
      @unchecked_value = unchecked_value

      @system_arguments = system_arguments
      @system_arguments[:tag] = "span"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Checkbox",
        "Polaris-Checkbox--labelHidden": label_hidden,
        "Polaris-Checkbox--error": error.present?,
      )

      @wrapper_arguments = {
        label: label,
        label_hidden: label_hidden,
        disabled: disabled,
        help_text: help_text,
        error: error,
      }.merge(wrapper_arguments)

      @input_options = input_options
      @input_options[:aria] ||= {}
      @input_options[:disabled] = true if disabled
      @input_options[:aria][:checked] = checked
      if indeterminate?
        @input_options[:indeterminate] = true
        @input_options[:aria][:checked] = "mixed"
      end
      @input_options[:class] = class_names(
        @input_options[:classes],
        "Polaris-Checkbox__Input",
        "Polaris-Checkbox__Input--indeterminate": indeterminate?,
      )
    end

    def indeterminate?
      @checked == :indeterminate
    end

    def icon_name
      indeterminate? ? "MinusMinor" : "TickSmallMinor"
    end

    def before_render
      validate!
    end
  end
end
