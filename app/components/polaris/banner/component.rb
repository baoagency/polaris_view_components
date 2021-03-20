# frozen_string_literal: true

module Polaris
  module Banner
    class Component < Polaris::Component
      include ActionHelper

      ALLOWED_STATUSES = %w[success info warning critical]

      validates :status, inclusion: { in: ALLOWED_STATUSES, message: "%{value} is not a valid status" }
      validates :action, type: ComplexAction, allow_nil: true
      validates :secondary_action, type: ComplexAction, allow_nil: true

      attr_reader :status, :action, :secondary_action

      # UNFINISHED, DO NOT USE YET

      def initialize(title: '', icon: nil, status: '', action: nil, secondary_action: nil, can_dismiss: false, within_content: false, **args)
        super

        @title = title
        @icon = icon
        @status = status
        @action = action
        @secondary_action = secondary_action
        @can_dismiss = can_dismiss
        @within_content = within_content
      end

      private

        def additional_aria
          {
            'aria-live': 'polite'
          }
        end

        def classes
          classes = ['Polaris-Banner']

          classes << "Polaris-Banner--status#{@status.camelize}" if @status.present?
          classes << 'Polaris-Banner--hasDismiss' if @can_dismiss

          if @within_content
            classes << 'Polaris-Banner--withinContentContainer'
          else
            classes << 'Polaris-Banner--withinPage'
          end

          classes
        end
    end
  end
end
