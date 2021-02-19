# frozen_string_literal: true

module Polaris
  module ProgressBar
    class Component < Polaris::Component
      ALLOWED_SIZES = %w[small medium large]
      DEFAULT_SIZE = 'medium'

      validates :size, inclusion: { in: ALLOWED_SIZES, message: "%{value} is not a valid size" }

      attr_reader :progress, :size

      def initialize(progress:, size: DEFAULT_SIZE, **args)
        super

        @progress = progress
        @size = size
      end

      private

        def classes
          ['Polaris-ProgressBar', "Polaris-ProgressBar--size#{@size.camelize}"]
        end
    end
  end
end
