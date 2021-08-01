# frozen_string_literal: true

module Polaris
  module Layout
    class AnnotatedSection < Polaris::NewComponent
      attr_reader :position

      def initialize(position:, title:, description: nil, **system_arguments)
        @position = position
        @title = title
        @description = description

        @system_arguments = system_arguments
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Layout__AnnotatedSection",
        )
      end
    end
  end
end
