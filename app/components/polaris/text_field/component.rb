# frozen_string_literal: true

module Polaris
  module TextField
    class Component < Polaris::Component
      with_content_areas :connected_left, :connected_right

      def initialize(label:, placeholder:, type: 'text', value: '', form: nil, **args)
        super

        @label = label
        @placeholder = placeholder
        @type = type
        @value = value
        @form = form
      end
    end
  end
end
