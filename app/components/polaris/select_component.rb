# frozen_string_literal: true

module Polaris
  class SelectComponent < Polaris::Component
    def initialize(
      options:,
      form: nil,
      attribute: nil,
      name: nil,
      selected: nil,
      disabled_options: nil,
      label: nil,
      label_hidden: false,
      label_inline: false,
      label_action: nil,
      disabled: false,
      required: false,
      help_text: nil,
      error: false,
      wrapper_arguments: {},
      select_options: {},
      input_options: {},
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @options = options
      @selected = selected
      @disabled_options = disabled_options
      @label = label
      @label_hidden = label_hidden
      @label_inline = label_inline
      @disabled = disabled

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:data] ||= {}
      prepend_option(@system_arguments[:data], :controller, "polaris-select")
      prepend_option(@system_arguments[:data], :selected_value, @selected)
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Select",
        "Polaris-Select--disabled": disabled,
        "Polaris-Select--error": error
      )

      @wrapper_arguments = {
        form: form,
        attribute: attribute,
        name: name,
        label: label,
        label_hidden: hides_label?,
        label_action: label_action,
        required: required,
        help_text: help_text,
        error: error
      }.merge(wrapper_arguments)

      @select_options = select_options

      @input_options = input_options
      @input_options.deep_merge!(select_options) unless @form
      @input_options[:class] = class_names(@input_options[:classes], "Polaris-Select__Input")
      @input_options[:disabled] = disabled
      @input_options[:data] ||= {}
      prepend_option(@input_options[:data], :polaris_select_target, "select")
      prepend_option(@input_options[:data], :action, "polaris-select#update")
    end

    def hides_label?
      @label_hidden || @label_inline
    end

    def selected_option
      option = @options.to_a.find { |i| i.last.to_s == @selected.to_s }
      return unless option

      option.first
    end
  end
end
