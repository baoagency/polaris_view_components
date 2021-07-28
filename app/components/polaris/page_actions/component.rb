# frozen_string_literal: true

module Polaris
  module PageActions
    class Component < Polaris::Component
      include Polaris::Helpers::ActionHelper

      validates :primary_action, type: Polaris::ComplexAction, allow_nil: false
      validates :secondary_actions, type: Polaris::ComplexAction, allow_nil: true

      attr_reader :primary_action, :secondary_actions

      def initialize(
        primary_action:,
        secondary_actions: [],
        **args
      )
        super

        @primary_action = primary_action
        @secondary_actions = secondary_actions
      end

      def stack_distribution
        @secondary_actions.present? ? 'equal_spacing' : 'trailing'
      end

      private

        def classes
          ["Polaris-PageActions"]
        end
    end
  end
end
