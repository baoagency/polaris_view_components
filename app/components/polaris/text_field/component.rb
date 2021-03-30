# frozen_string_literal: true
module Polaris
  module TextField
    class Component < Polaris::Component
      include ActionHelper

      with_content_areas :connected_left, :connected_right

      validates :label_action, type: Action, allow_nil: true
      validates :index, numericality: { only_integer: true }, allow_nil: true

      attr_reader :label_action, :index

      def initialize(
        form:,
        attribute:,
        placeholder: "",
        type: "text",
        error: "",
        label: nil,
        label_action: nil,
        label_hidden: false,
        multiline: false,
        help_text: "",
        index: nil,
        **args
      )
        super
        @placeholder = placeholder
        @type = type
        @form = form
        @attribute = attribute
        @error = error
        @label = label
        @label_action = label_action
        @label_hidden = label_hidden
        @multiline = multiline
        @index = index
      end

      def labelled_attrs
        {
          form: @form,
          attr: @attribute,
          error: @error,
          label: @label,
          label_hidden: @label_hidden,
          help_text: @help_text,
          index: @index,
          action: @label_action
        }
      end

      def input
        @multiline ? "text_area" : "text_field"
      end

      def input_attrs
        attrs = {
          class: 'Polaris-TextField__Input',
          placeholder: @placeholder,
          rows: @multiline || nil,
        }

        if @index.present?
          attrs[:index] = @index
        end

        attrs
      end

      private

        def classes
          classes = ['Polaris-TextField']

          classes << 'Polaris-TextField--error' if @error.present?

          classes
        end
    end
  end
end
