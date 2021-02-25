# frozen_string_literal: true

module Polaris
  module Stack
    class Component < Polaris::Component
      ALLOWED_ALIGNMENT = %w[leading trailing center fill baseline]
      ALLOWED_DISTRIBUTION = %w[equal_spacing leading trailing center fill fill_evenly]
      ALLOWED_SPACING = %w[extra_tight tight loose extra_loose none]

      validates :alignment, inclusion: {
        in: ALLOWED_ALIGNMENT,
        message: "%{value} is not a valid alignment"
      }, allow_blank: true
      validates :distribution, inclusion: {
        in: ALLOWED_DISTRIBUTION,
        message: "%{value} is not a valid distribution"
      }, allow_blank: true
      validates :spacing, inclusion: {
        in: ALLOWED_SPACING,
        message: "%{value} is not a valid spacing"
      }, allow_blank: true

      attr_reader :alignment, :distribution, :spacing

      def initialize(alignment: '', distribution: '', spacing: '', vertical: false, wrap: true, **args)
        super

        @alignment = alignment
        @distribution = distribution
        @spacing = spacing
        @vertical = vertical
        @wrap = wrap
      end

      private

        def classes
          classes = ['Polaris-Stack']

          classes << "Polaris-Stack--spacing#{@spacing.camelize}" if @spacing.present?
          classes << "Polaris-Stack--alignment#{@alignment.camelize}" if @alignment.present?
          classes << "Polaris-Stack--distribution#{@distribution.camelize}" if @distribution.present?
          classes << "Polaris-Stack--vertical" if @vertical
          classes << "Polaris-Stack--noWrap" unless @wrap

          classes
        end

        def before_render
          super

          wrap_children! 'Polaris-Stack__Item'
        end
    end
  end
end
