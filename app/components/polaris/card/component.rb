# frozen_string_literal: true
module Polaris
  module Card
    class Component < Polaris::Component
      include ActionHelper

      validates :primary_footer_action, type: ComplexAction, allow_nil: true

      with_content_areas :header

      attr_reader :primary_footer_action

      def initialize(title: '', primary_footer_action: nil, sectioned: false, **args)
        super

        @title = title
        @primary_footer_action = primary_footer_action
        @sectioned = sectioned
      end

      def footer?
        primary_footer_action.present?
      end

      private

        def classes
          ['Polaris-Card']
        end

        def before_render
          super

          return unless @sectioned

          wrap_children! 'Polaris-Card__Section'
        end
    end
  end
end
