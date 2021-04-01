# frozen_string_literal: true

module Polaris
  module Thumbnail
    class Component < Polaris::Component
      DEFAULT_SIZE = 'medium'

      ALLOWED_SIZES = %w[small medium large]

      validates :size, inclusion: { in: ALLOWED_SIZES, message: "%{value} is not a valid size" }

      attr_reader :size

      def initialize(alt:, size: DEFAULT_SIZE, source: "", **args)
        super

        @alt = alt
        @size = size
        @source = source
      end

      private

        def classes
          classes = ["Polaris-Thumbnail"]

          classes << "Polaris-Thumbnail--size#{@size.capitalize}"

          classes
        end
    end
  end
end
