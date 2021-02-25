# frozen_string_literal: true

module Polaris
  module Link
    class Component < Polaris::Component
      def initialize(href:, **args)
        super

        @href = href
      end

      private

        def classes
          ['Polaris-Link']
        end
    end
  end
end
