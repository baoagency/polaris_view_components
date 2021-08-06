# frozen_string_literal: true

module Polaris
  class SelectComponent < Polaris::NewComponent
    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      options:,
      selected: nil,
      label: nil,
      label_hidden: false,
      label_inline: false,
      disabled: false,
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
      @label_hidden = label_hidden
      @label_inline = label_inline
      @disabled = disabled

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:data] ||= {}
      @system_arguments[:data][:controller] = "polaris-select"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Select",
        "Polaris-Select--disabled": disabled,
      )

      @wrapper_arguments = {
        form: form,
        attribute: attribute,
        name: name,
        label: label,
        label_hidden: hides_label?,
        help_text: help_text,
        error: error,
      }.merge(wrapper_arguments)

      @select_options = {}

      @input_options = input_options
      @input_options[:class] = class_names(@input_options[:classes], "Polaris-Select__Input")
    end

    def hides_label?
      @label_hidden || @label_inline
    end

    def selected_option
      option = @options.to_a.find { |i| i.last.to_s == @selected.to_s }
      option ? option.first : @options.first.first
    end
  end
end
