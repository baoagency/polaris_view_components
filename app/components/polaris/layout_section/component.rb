# frozen_string_literal: true

module Polaris
  module LayoutSection
    class Component < Polaris::Component
      def initialize(secondary: false, full_width: false, one_half: false, one_third: false, **args)
        super

        @secondary = secondary
        @full_width = full_width
        @one_half = one_half
        @one_third = one_third
      end

      private

        def classes
          classes = ['Polaris-Layout__Section']

          classes << 'Polaris-Layout__Section--secondary' if @secondary
          classes << 'Polaris-Layout__Section--fullWidth' if @full_width
          classes << 'Polaris-Layout__Section--oneHalf' if @one_half
          classes << 'Polaris-Layout__Section--oneThird' if @one_third

          classes
        end
    end
  end
end
