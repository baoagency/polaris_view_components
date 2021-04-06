# frozen_string_literal: true
module Polaris
  module Card
    class Component < Polaris::Component
      include ActionHelper

      ALLOWED_FOOTER_ACTION_ALIGNMENT = %w[right left]

      validates :primary_footer_action, type: ComplexAction, allow_nil: true
      validates :footer_action_alignment, inclusion: {
        in: ALLOWED_FOOTER_ACTION_ALIGNMENT,
        message: "%{value} is not a valid footer_action_alignment"
      }, allow_blank: true, allow_nil: true

      with_content_areas :header

      attr_reader :primary_footer_action, :footer_action_alignment

      def initialize(
        title: '',
        primary_footer_action: nil,
        secondary_footer_actions: [],
        footer_action_alignment: 'right',
        sectioned: false,
        **args
      )
        super

        @title = title
        @primary_footer_action = primary_footer_action
        @secondary_footer_actions = secondary_footer_actions
        @footer_action_alignment = footer_action_alignment
        @sectioned = sectioned
      end

      def footer?
        primary_footer_action.present? || @secondary_footer_actions.present?
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
