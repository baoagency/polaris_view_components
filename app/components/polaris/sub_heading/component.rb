# frozen_string_literal: true

module Polaris
  module SubHeading
    class Component < Polaris::Component
      ALLOWED_ELEMENTS = %w[p h1 h2 h3 h4 h5 h6]

      validates :element, inclusion: { in: ALLOWED_ELEMENTS, message: "%{value} is not a valid element" }

      attr_reader :element

      def initialize(element: ALLOWED_ELEMENTS.fourth, **args)
        super

        @element = element
      end

      private

        def classes
          ['Polaris-Subheading']
        end
    end
  end
end
