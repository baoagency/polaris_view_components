# frozen_string_literal: true
module Polaris
  module TextField
    class Component < Polaris::Component
      include Polaris::Helpers::ActionHelper

      with_content_areas :connected_left, :connected_right

      validates :label_action, type: Action, allow_nil: true
      validates :index, numericality: { only_integer: true }, allow_nil: true

      attr_reader :label_action, :index, :value

      def initialize(
        attribute:,
        form: nil,
        placeholder: "",
        type: "text",
        align: "",
        error: "",
        label: nil,
        label_action: nil,
        label_hidden: false,
        multiline: false,
        help_text: "",
        disabled: false,
        index: nil,
        step: 1,
        prefix: nil,
        suffix: nil,
        max: 1_000_000,
        min: 0,
        value: nil,
        show_character_count: false,
        max_length: nil,
        min_length: nil,
        clear_button: false,
        monospaced: false,
        input_attrs: {},
        **args
      )
        super
        @placeholder = placeholder
        @type = type
        @form = form
        @align = align
        @attribute = attribute
        @error = error
        @label = label
        @label_action = label_action
        @label_hidden = label_hidden
        @multiline = multiline
        @help_text = help_text
        @disabled = disabled
        @index = index
        @step = step
        @prefix = prefix
        @suffix = suffix
        @max = max
        @min = min
        @value = value
        @show_character_count = show_character_count
        @max_length = max_length
        @min_length = min_length
        @clear_button = clear_button
        @monospaced = monospaced
        @input_attrs = input_attrs
      end

      def labelled_attrs
        {
          form: @form,
          attribute: @attribute,
          error: @error,
          label: @label,
          label_hidden: @label_hidden,
          help_text: @help_text,
          index: @index,
          action: @label_action
        }
      end

      def input
        return 'number_field' if number?

        @multiline ? "text_area" : "text_field"
      end

      def input_tag
        input + '_tag'
      end

      def number?
        @type == 'number' && @step != 0
      end

      def input_attrs
        attrs = @input_attrs.merge({
          placeholder: @placeholder,
          rows: @multiline || nil,
          disabled: @disabled,
        })

        input_class = "Polaris-TextField__Input"
        input_class += " Polaris-TextField__Input--align#{@align.capitalize}" if @align.present?
        input_class += " Polaris-TextField__Input--suffixed" if @suffix.present?
        input_class += " Polaris-TextField--monospaced" if @monospaced

        attrs[:class] = input_class
        attrs[:maxlength] = @max_length if @max_length.present?
        attrs[:minlength] = @min_length if @min_length.present?

        if @index.present?
          attrs[:index] = @index
        end

        if number?
          attrs[:step] = @step
          attrs[:min] = @min
          attrs[:max] = @max
        end

        if attach_stimulus_controller?
          attrs[:data] = {
            "polaris--text-field-target": "input",
            "action": "input->polaris--text-field#handleInput"
          }
        end

        if @value.present?
          attrs[:value] = @value
        end

        attrs
      end

      def character_count
        @character_count ||= CharacterCount.new(text_field: self, max_length: @max_length)
      end

      private
        def attach_stimulus_controller?
          number? or @clear_button or @show_character_count
        end

        def additional_data
          data = {}

          data["controller"] = "polaris--text-field" if attach_stimulus_controller?
          data["polaris--text-field-value-value"] = @value

          if number?
            data = {
              "polaris--text-field-min-value": @min,
              "polaris--text-field-max-value": @max,
            }
          end

          if @clear_button
            data["polaris--text-field-clear-button-visibility-class"] = "Polaris-TextField__ClearButton--hidden"
          end

          if @show_character_count
            data["polaris--text-field-max-length-value"] = @max_length if @max_length.present?
            data["polaris--text-field-label-template-value"] = character_count.label_template
            data["polaris--text-field-text-template-value"] = character_count.text_template
          end

          data
        end

        def classes
          classes = ['Polaris-TextField']

          classes << 'Polaris-TextField--hasValue' if @value.present?
          classes << 'Polaris-TextField--error' if @error.present?
          classes << 'Polaris-TextField--disabled' if @disabled
          classes << 'Polaris-TextField--multiline' if @multiline.present?

          classes
        end
    end
  end
end
