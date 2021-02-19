# frozen_string_literal: true

module Polaris
  module DisplayText
    class Component < Polaris::Component
      attr_reader :element, :size

      ALLOWED_ELEMENTS = %w[p h1 h2 h3 h4 h5 h6]
      ALLOWED_SIZES = %w[small medium large extra_large]

      validates :element, inclusion: { in: ALLOWED_ELEMENTS, message: "%{value} is not a valid element" }
      validates :size, inclusion: { in: ALLOWED_SIZES, message: "%{value} is not a valid size" }

      def initialize(element: ALLOWED_ELEMENTS.first, size: ALLOWED_SIZES.second, **args)
        super

        @element = element
        @size = size
      end

      private

        def classes
          ['Polaris-DisplayText', "Polaris-DisplayText--size#{size.camelize}"]
        end
    end
  end
end
