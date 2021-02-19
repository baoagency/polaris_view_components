# frozen_string_literal: true
require 'nokogiri'

module Polaris
  module Layout
    class Component < Polaris::Component
      def initialize(sectioned: false, **args)
        super

        @sectioned = sectioned
      end

      private

        def classes
          ['Polaris-Layout']
        end

        def before_render
          super

          return unless @sectioned

          wrap_children! 'Polaris-Layout__Section'
        end
    end
  end
end
