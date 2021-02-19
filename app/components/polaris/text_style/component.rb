# frozen_string_literal: true

module Polaris
  module TextStyle
    class Component < Polaris::Component
      ALLOWED_VARIATIONS = %w[positive negative strong subdued code]

      validates :variation, inclusion: {
        in: ALLOWED_VARIATIONS,
        message: "%{value} is not a valid variation"
      }, allow_blank: true

      attr_reader :variation

      def initialize(variation: '', **args)
        super

        @variation = variation
      end

      private

        def classes
          classes = ['Polaris-TextStyle']

          classes << "Polaris-TextStyle--variation#{@variation.camelize}" if @variation.present?

          classes
        end
    end

  end
end
