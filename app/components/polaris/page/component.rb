# frozen_string_literal: true

module Polaris
  module Page
    class Component < ApplicationComponent
      include ActionHelper

      validates :primary_action, type: ComplexAction, allow_blank: true

      attr_reader :primary_action

      def initialize(title:, subtitle: '', title_hidden: false, narrow_width: false, primary_action: nil, **args)
        super

        @title = title
        @subtitle = subtitle
        @title_hidden = title_hidden
        @narrow_width = narrow_width
        @primary_action = primary_action
      end

      def classes_header
        css_classes = []

        css_classes << 'Polaris-Page-Header--titleHidden' if @title_hidden

        css_classes.compact.join ' '
      end

      private

        def classes
          classes = ['Polaris-Page']

          classes << 'Polaris-Page--narrowWidth' if @narrow_width

          classes
        end
    end
  end
end
