# frozen_string_literal: true

module Polaris
  module ButtonGroup
    class Component < Polaris::Component
      ALLOWED_SPACING = %w[extra_tight tight loose]

      validates_inclusion_of :connected_top, in: [true, false]
      validates_inclusion_of :full_width, in: [true, false]
      validates_inclusion_of :segmented, in: [true, false]

      validates :spacing, inclusion: { in: ALLOWED_SPACING, message: "%{value} is not a valid spacing" }, allow_blank: true, allow_nil: true

      attr_reader :connected_top, :full_width, :segmented, :spacing

      def initialize(connected_top: false, full_width: false, segmented: false, spacing: '', **args)
        super

        @connected_top = connected_top
        @full_width = full_width
        @segmented = segmented
        @spacing = spacing
      end

      private

        def additional_data
          additional_data = {}

          additional_data['buttongroup-connected-top'] = 'true' if @connected_top
          additional_data['buttongroup-full-width'] = 'true' if @full_width
          additional_data['buttongroup-segmented'] = 'true' if @segmented

          additional_data
        end

        def classes
          classes = ['Polaris-ButtonGroup']

          classes << 'Polaris-ButtonGroup--fullWidth' if @full_width
          classes << 'Polaris-ButtonGroup--segmented' if @segmented
          classes << "Polaris-ButtonGroup--#{@spacing.camelize(:lower)}" if @spacing != ''

          classes
        end

        def before_render
          super

          wrap_children! 'Polaris-ButtonGroup__Item'
        end
    end
  end
end
