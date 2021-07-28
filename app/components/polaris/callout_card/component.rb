# frozen_string_literal: true

module Polaris
  module CalloutCard
    class Component < Polaris::Component
      include Polaris::Helpers::ActionHelper

      validates :primary_action, type: Polaris::ComplexAction, allow_nil: false
      validates :secondary_action, type: Polaris::ComplexAction, allow_nil: true

      attr_reader :primary_action, :secondary_action

      def initialize(title:, illustration:, primary_action:, secondary_action: nil, can_close: false, **args)
        super

        @title = title
        @illustration = illustration
        @primary_action = primary_action
        @secondary_action = secondary_action
        @can_close = can_close
      end

      def can_close?
        @can_close
      end

      def image_class
        classes = ["Polaris-CalloutCard__Image"]

        classes << "Polaris-CalloutCard__DismissImage" if can_close?

        classes.join ' '
      end

      def parent_data
        return {} unless can_close?

        {
          "controller": "polaris--callout-card"
        }
      end

      private

        def classes
          ["Polaris-CalloutCard"]
        end
    end
  end
end
