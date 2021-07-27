# frozen_string_literal: true

module Polaris
  module EmptyState
    class Component < Polaris::Component
      include Polaris::ActionHelper

      validates :action, type: Polaris::ComplexAction
      validates :secondary_action, type: Polaris::ComplexAction, allow_nil: true

      attr_reader :action, :secondary_action

      def initialize(heading:, action:, image:, secondary_action: nil, full_width: false, **args)
        super

        @heading = heading
        @action = action
        @secondary_action = secondary_action
        @image = image
        @full_width = full_width
      end

      private

        def classes
          %w[Polaris-EmptyState Polaris-EmptyState--withinPage]
        end
    end
  end
end
