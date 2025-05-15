# frozen_string_literal: true

module Polaris
  class SelectComponent < Polaris::Component
    def initialize(
      options: {},
      form: nil,
      attribute: nil,
      name: nil,
      selected: nil,
      disabled_options: nil,
      label: nil,
      prompt: nil,
      divider: nil,
      time_zone: nil,
      label_hidden: false,
      label_inline: false,
      label_action: nil,
      disabled: false,
      required: false,
      help_text: nil,
      error: false,
      grouped: false,
      clear_errors_on_focus: false,
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
      @grouped = grouped
      @prompt = prompt
      @divider = divider
      @time_zone = time_zone

      if @time_zone
        @options = ::ActiveSupport::TimeZone.all
      end

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

      @clear_errors_on_focus = clear_errors_on_focus
      @select_options = select_options

      @input_options = input_options
      @input_options.deep_merge!(select_options) unless @form
      @input_options[:class] = class_names(@input_options[:classes], "Polaris-Select__Input")
      @input_options[:disabled] = disabled
      @input_options[:data] ||= {}
      prepend_option(@input_options[:data], :polaris_select_target, "select")
      if @clear_errors_on_focus
        prepend_option(@input_options[:data], :action, "click->polaris-select#clearErrorMessages")
      end
      prepend_option(@input_options[:data], :action, "polaris-select#update")
    end

    def hides_label?
      @label_hidden || @label_inline
    end

    def selected_option
      if @grouped
        grouped_selected_option
      else
        options_to_find = @time_zone ? @options.map { |z| [z.to_s, z.name] } : @options.to_a
        option = options_to_find.find { |i| i.last.to_s == @selected.to_s }
        return unless option

        option.first
      end
    end

    def build_options_for_select
      if @grouped
        grouped_options_for_select(
          @options,
          @selected,
          disabled: @disabled_options,
          prompt: @prompt,
          divider: @divider
        )
      elsif @time_zone
        time_zone_options_for_select(@selected)
      else
        options_for_select(@options, selected: @selected, disabled: @disabled_options)
      end
    end

    private

    def grouped_selected_option
      @options.each do |group|
        group_to_traverse = @divider ? group[1] : group
        if group_to_traverse.is_a?(String)
          return group_to_traverse if group_to_traverse == @selected.to_s

          next
        end

        group_to_traverse.each do |item|
          if item.is_a?(Array) && item[1] == @selected.to_s
            return item[0]
          elsif item.is_a?(String) && item == @selected.to_s
            return item
          end
        end
      end
    end
  end
end
