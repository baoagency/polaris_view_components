# frozen_string_literal: true

module Polaris
  module Icon
    class Component < Polaris::Component
      ALLOWED_COLORS = %w[base subdued critical warning highlight success primary]

      validates :color, inclusion: { in: ALLOWED_COLORS, message: "%{value} is not a valid color" }, allow_blank: true
      validates_inclusion_of :backdrop, in: [true, false]

      attr_reader :backdrop, :color

      def initialize(accessibility_label: '', backdrop: false, color: '', **args)
        super

        @accessibility_label = accessibility_label
        @backdrop = backdrop
        @color = color
      end

      private

        def classes
          classes = ['Polaris-Icon']

          classes << 'Polaris-Icon--hasBackdrop' if @backdrop
          classes << "Polaris-Icon--color#{@color.camelize}" if @color.present?

          classes
        end

        def additional_aria
          attrs = {}

          attrs['aria-label'] = @accessibility_label if @accessibility_label.present?

          attrs
        end
    end
  end
end
