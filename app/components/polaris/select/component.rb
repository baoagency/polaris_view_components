# frozen_string_literal: true

module Polaris
  module Select
    class Component < Polaris::Component
      include ConditionalHelper

      def initialize(
        label: nil,
        options:,
        disabled: false,
        error: '',
        help_text: '',
        id: '',
        label_hidden: false,
        label_inline: false,
        name: '',
        placeholder: '',
        value: '',
        form: nil,
        attribute: nil,
        **args
      )
        super

        @label = label
        @options = options
        @disabled = disabled
        @error = error
        @help_text = help_text
        @id = id
        @label_hidden = label_hidden
        @label_inline = label_inline
        @name = name
        @placeholder = placeholder
        @value = value
        @form = form
        @attribute = attribute
      end

      def options
        if @options.first.is_a? Array
          @options
        elsif @options.first.is_a? Hash
          @options.map do |option|
            [option[:label], option[:value]]
          end
        end
      end

      def select_content
        data = {
          class: 'Polaris-Select__Input',
          data: {
            'polaris--select-target': 'select',
            'action': 'polaris--select#onChange'
          }
        }

        data[:disabled] = true if @disabled

        data
      end

      def selected_option
        r = options.find { |option| option.last.to_s == @value.to_s }
        return r.first if r
        options.first.first
      end

      def label_hidden?
        @label_inline || @label_hidden
      end

      private

      def additional_data
        {
          "controller": "polaris--select"
        }
      end
    end
  end
end
