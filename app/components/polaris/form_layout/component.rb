# frozen_string_literal: true

module Polaris
  module FormLayout
    class Component < Polaris::Component
      def initialize(sectioned: false, **args)
        super

        @sectioned = sectioned
      end

      private

      def classes
        ["Polaris-FormLayout"]
      end

      def before_render
        super

        return unless @sectioned

        wrap_children! "Polaris-FormLayout__Item", exclusions: "[class*='Polaris-FormLayout--']"
      end
    end
  end
end
