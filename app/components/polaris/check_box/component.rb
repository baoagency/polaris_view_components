# frozen_string_literal: true

module Polaris
  module CheckBox
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
        attrs = {
          disabled: @disabled,
          aria: {
            checked: checked?
          }
        }

        classes = ["Polaris-Checkbox__Input"]
        classes << "Polaris-Checkbox__Input--indeterminate" if indeterminate?

        attrs[:class] = classes.compact.join ' '

        if indeterminate?
          attrs[:indeterminate] = true
          attrs[:aria][:checked] = 'mixed'
        end

        attrs
      end

      def indeterminate?
        @checked === 'indeterminate'
      end

      def checked?
        !indeterminate? && @checked
      end

      def icon
        if indeterminate?
          return '<path d="M15 9H5a1 1 0 1 0 0 2h10a1 1 0 1 0 0-2z"></path>'
        end

        '<path d="m8.315 13.859-3.182-3.417a.506.506 0 0 1 0-.684l.643-.683a.437.437 0 0 1 .642 0l2.22 2.393 4.942-5.327a.436.436 0 0 1 .643 0l.643.684a.504.504 0 0 1 0 .683l-5.91 6.35a.437.437 0 0 1-.642 0"></path>'
      end

      private

        def classes
          classes = ['Polaris-Checkbox']

          classes << 'Polaris-Checkbox--labelHidden' if @label_hidden

          classes
        end
    end
  end
end
