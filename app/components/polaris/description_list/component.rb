# frozen_string_literal: true

module Polaris
  module DescriptionList
    class Component < Polaris::Component
      attr_reader :spacing

      ALLOWED_SPACING = %w[tight loose]

      validates :spacing, inclusion: { in: ALLOWED_SPACING, message: "%{value} is not a valid spacing" }, allow_nil: true

      def initialize(items:, spacing: nil, **args)
        super

        @items = items
        @spacing = spacing
      end

      private

        def classes
          classes = ['Polaris-DescriptionList']

          classes << "Polaris-DescriptionList--spacing#{@spacing.capitalize}" if @spacing.present?

          classes
        end
    end
  end
end
