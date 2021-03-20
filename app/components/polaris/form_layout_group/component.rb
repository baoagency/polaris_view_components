# frozen_string_literal: true

module Polaris
  module FormLayoutGroup
    class Component < Polaris::Component
      def initialize(sectioned: false, condensed: false, title: '', help_text: '', **args)
        super

        @sectioned = sectioned
        @condensed = condensed
        @title = title
        @help_text = help_text
      end

      private

        def html_options
          { role: 'group' }
        end

        def classes
          [
            @condensed ? "Polaris-FormLayout--condensed" : "Polaris-FormLayout--grouped"
          ]
        end

        def before_render
          super

          return unless @sectioned

          wrap_children! "Polaris-FormLayout__Item"
        end
    end
  end
end
