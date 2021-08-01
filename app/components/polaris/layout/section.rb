# frozen_string_literal: true

module Polaris
  module Layout
    class Section < Polaris::NewComponent
      attr_reader :position

      def initialize(
        position:,
        secondary: false,
        full_width: false,
        one_half: false,
        one_third: false,
        **system_arguments
      )
        @position = position

        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Layout__Section",
          "Polaris-Layout__Section--secondary" => secondary,
          "Polaris-Layout__Section--fullWidth" => full_width,
          "Polaris-Layout__Section--oneHalf" => one_half,
          "Polaris-Layout__Section--oneThird" => one_third,
        )
      end

      def call
        render(Polaris::BaseComponent.new(**@system_arguments)) { content }
      end
    end
  end
end
