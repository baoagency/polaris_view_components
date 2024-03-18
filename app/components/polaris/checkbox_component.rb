# frozen_string_literal: true

module Polaris
  class CheckboxComponent < Polaris::Component
    include ActiveModel::Validations

    attr_reader :checked

    validates :checked, inclusion: {in: [true, false, :indeterminate]}

    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      label: nil,
      label_hidden: false,
      checked: false,
      disabled: false,
      multiple: false,
      help_text: nil,
      error: nil,
      value: "1",
      unchecked_value: "0",
      wrapper_arguments: {},
      input_options: {},
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @checked = checked
      @disabled = disabled
      @multiple = multiple
      @value = value
      @unchecked_value = unchecked_value

      @system_arguments = system_arguments
      @system_arguments[:tag] = "span"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Checkbox",
        "Polaris-Checkbox--labelHidden": label_hidden,
        "Polaris-Checkbox--error": error.present?
      )

      @wrapper_arguments = {
        label: label,
        label_hidden: label_hidden,
        disabled: disabled,
        help_text: help_text,
        error: error
      }.merge(wrapper_arguments)

      @input_options = input_options
      @input_options[:classes] = class_names(
        @input_options[:classes],
        "Polaris-Checkbox__Input",
        "Polaris-Checkbox__Input--indeterminate": indeterminate?
      )
    end

    def indeterminate?
      @checked == :indeterminate
    end

    def icon_name
      indeterminate? ? "MinusIcon" : "CheckSmallIcon"
    end

    def before_render
      validate!
    end

    def checkbox
      render Polaris::BaseCheckbox.new(
        form: @form,
        attribute: @attribute,
        name: @name,
        checked: @checked,
        disabled: @disabled,
        multiple: @multiple,
        value: @value,
        unchecked_value: @unchecked_value,
        **@input_options
      )
    end
  end
end
