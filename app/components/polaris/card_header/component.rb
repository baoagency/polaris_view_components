# frozen_string_literal: true

module Polaris
  module CardHeader
    class Component < Polaris::Component
      include ComplexActionHelper

      with_content_areas :title

      def initialize(actions: [], **args)
        super

        @actions = actions
      end

      private

        def classes
          ['Polaris-Card__Header']
        end
    end
  end
end
