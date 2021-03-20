# frozen_string_literal: true

module Polaris
  module Label
    class Component < Polaris::Component
      validates :index, numericality: { only_integer: true }, allow_nil: true

      attr_reader :index

      def initialize(form:, attr:, label: "", id: "", hidden: false, index: nil, **args)
        super

        @form = form
        @attr = attr
        @label = label
        @id = id
        @hidden = hidden
        @index = index
      end

      private

        def classes
          classes = ["Polaris-Label"]

          classes << "Polaris-Label--hidden" if @hidden

          classes
        end
    end
  end
end
