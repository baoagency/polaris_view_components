# frozen_string_literal: true

module Polaris
  module StackItem
    class Component < Polaris::Component
      def initialize(fill: false, **args)
        super

        @fill = fill
      end

      private

        def classes
          classes = ['Polaris-Stack__Item']

          classes << 'Polaris-Stack__Item--fill' if @fill

          classes
        end
    end
  end
end
