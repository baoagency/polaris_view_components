# frozen_string_literal: true

module Polaris
  module Link
    class Component < Polaris::Component
      def initialize(
        href:,
        monochrome: false,
        external: false,
        **args
      )
        super

        @href = href
        @monochrome = monochrome
        @external = external
      end

      private

        def classes
          classes = ['Polaris-Link']
          classes << 'Polaris-Link--monochrome' if @monochrome
          classes
        end
    end
  end
end
