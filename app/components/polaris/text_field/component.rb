# frozen_string_literal: true
module Polaris
  module TextField
    class Component < Polaris::Component
      with_content_areas :connected_left, :connected_right

      def initialize(form:, attribute:, placeholder: "", type: "text", error: "", label: nil, multiline: false, **args)
        super
        @placeholder = placeholder
        @type = type
        @form = form
        @attribute = attribute
        @error = error
        @label = label
        @multiline = multiline
      end

      def input
        @multiline ? "text_area" : "text_field"
      end
    end
  end
end
