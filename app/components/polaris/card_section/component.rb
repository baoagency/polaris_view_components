# frozen_string_literal: true

module Polaris
  module CardSection
    class Component < Polaris::Component
      with_content_areas :header

      def initialize(title: '', subdued: false, flush: false, full_width: false, actions: [], **args)
        super

        @title = title
        @subdued = subdued
        @flush = flush
        @full_width = full_width
        @actions = actions
      end

      private

        def classes
          classes = ['Polaris-Card__Section']

          classes << 'Polaris-Card__Section--flush' if @flush
          classes << 'Polaris-Card__Section--subdued' if @subdued
          classes << 'Polaris-Card__Section--fullWidth' if @full_width

          classes
        end
    end
  end
end
