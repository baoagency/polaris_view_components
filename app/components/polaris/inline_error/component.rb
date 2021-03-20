# frozen_string_literal: true

module Polaris
  module InlineError
    class Component < Polaris::Component
      def initialize(error: "", id: "", **args)
        super

        @error = error
        @id = id
      end

      private

        def classes
          ["Polaris-InlineError"]
        end
    end
  end
end
