# frozen_string_literal: true

module Polaris
  module RadioButton
    class Component < Polaris::Component
      def initialize(
        aria_described_by: '',
        label: '',
        label_hidden: false,
        checked: false,
        help_text: '',
        disabled: false,
        id: '',
        name: '',
        value: '',
        form: nil,
        attribute: nil,
        children_content: nil,
        **args
      )
        super

        @aria_described_by = aria_described_by
        @label = label
        @label_hidden = label_hidden
        @checked = checked
        @help_text = help_text
        @disabled = disabled
        @id = id
        @name = name
        @value = value
        @form = form
        @attribute = attribute
        @children_content = children_content
      end

      def input_attrs
        {
          class: 'Polaris-RadioButton__Input',
          disabled: @disabled
        }
      end

      private

        def classes
          classes = ['Polaris-RadioButton']

          classes << 'Polaris-RadioButton--labelHidden' if @label_hidden

          classes
        end
    end
  end
end
