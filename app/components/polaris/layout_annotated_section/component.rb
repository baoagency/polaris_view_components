# frozen_string_literal: true

module Polaris
  module LayoutAnnotatedSection
    class Component < Polaris::Component
      validates_presence_of :title

      attr_reader :title

      def initialize(title:, description: '', **args)
        super

        @title = title
        @description = description
      end

      private

        def classes
          ['Polaris-Layout__AnnotatedSection']
        end
    end
  end
end
