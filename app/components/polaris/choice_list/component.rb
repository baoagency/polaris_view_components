# frozen_string_literal: true

module Polaris
  module ChoiceList
    class Component < Polaris::Component
      def initialize(
        choices:,
        form: nil,
        attribute: nil,
        name: nil,
        title: '',
        title_hidden: false,
        selected: [],
        allow_multiple: false,
        error: '',
        disabled: false,
        **args
      )
        super

        @choices = choices
        @form = form
        @attribute = attribute

        @name = name
        @title = title
        @title_hidden = title_hidden
        @selected = selected
        @allow_multiple = allow_multiple
        @error = error
        @disabled = disabled
      end

      def final_name
        return nil if @name.nil?

        @allow_multiple ? "#{@name}[]" : @name
      end

      def choice_is_selected?(choice)
        @selected.include? choice[:value]
      end

      private

        def classes
          classes = ['Polaris-ChoiceList']

          classes << 'Polaris-ChoiceList--titleHidden' if @title_hidden

          classes
        end

        def additional_aria
          super

          {
            invalid: @error.present?
          }
        end
    end
  end
end
