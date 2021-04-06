# frozen_string_literal: true

module Polaris
  module Labelled
    class Component < Polaris::Component
      include ActionHelper

      validates :action, type: Action, allow_nil: true
      validates :index, numericality: { only_integer: true }, allow_nil: true

      attr_reader :action, :index

      def initialize(form:, attribute:, id: "", label: "", error: "", action: nil, help_text: "", label_hidden: "", index: nil, **args)
        super

        @form = form
        @attribute = attribute
        @id = id
        @label = label
        @error = error
        @action = action
        @help_text = help_text
        @label_hidden = label_hidden
        @index = index
      end

      def label_attrs
        attrs = {
          form: @form,
          attribute: @attribute,
          hidden: false,
        }

        attrs[:index] = @index if @index.present?
        attrs[:label] = @label if @label.present?

        attrs
      end

      def error?
        @error.present? && @error.is_a?(String)
      end

      private

        def classes
          classes = []

          classes << "Polaris-Labelled--hidden" if @label_hidden

          classes
        end
    end
  end
end
