# frozen_string_literal: true

module Polaris
  module Choice
    class Component < Polaris::Component
      def initialize(
        id: '',
        label: '',
        disabled: false,
        error: false,
        label_hidden: false,
        help_text: '',
        name: '',
        form: nil,
        attribute: nil,
        **args
      )
        super

        @id = id
        @label = label
        @disabled = disabled
        @error = error
        @label_hidden = label_hidden
        @help_text = help_text
        @name = name
        @form = form
        @attribute = attribute
      end

      def description?
        @help_text.present? || @error.present?
      end

      private

        def classes
          classes = ['Polaris-Choice']

          classes << 'Polaris-Choice--labelHidden' if @label_hidden
          classes << 'Polaris-Choice--disabled' if @disabled

          classes
        end
    end
  end
end
