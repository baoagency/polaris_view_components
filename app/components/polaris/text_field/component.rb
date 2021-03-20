# frozen_string_literal: true
module Polaris
  module TextField
    class Component < Polaris::Component
      with_content_areas :connected_left, :connected_right

      validates :index, numericality: { only_integer: true }, allow_nil: true

      attr_reader :index

      def initialize(form:, attribute:, placeholder: "", type: "text", error: "", label: nil, label_hidden: false, multiline: false, help_text: "", index: nil, **args)
        super
        @placeholder = placeholder
        @type = type
        @form = form
        @attribute = attribute
        @error = error
        @label = label
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
        #  action
        }
      end

      def input
        @multiline ? "text_area" : "text_field"
      end
    end
  end
end
