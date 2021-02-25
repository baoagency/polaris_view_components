# frozen_string_literal: true

module Polaris
  module TextContainer
    class Component < Polaris::Component
      ALLOWED_SPACING = %w[tight loose]

      validates :spacing, inclusion: {
        in: ALLOWED_SPACING,
        message: "%{value} is not a valid spacing"
      }, allow_blank: true

      attr_reader :spacing

      def initialize(spacing: '', **args)
        super

        @spacing = spacing
      end

      private

        def classes
          classes = ['Polaris-TextContainer']

          classes << "Polaris-TextContainer--spacing#{@spacing.camelize}" if @spacing.present?

          classes
        end
    end
  end
end
