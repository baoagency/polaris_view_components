# frozen_string_literal: true

module Polaris
  module Image
    class Component < Polaris::Component
      def initialize(source:, alt:, sourceset: nil, cross_origin: nil, **args)
        super

        @source = source
        @alt = alt
        @sourceset = sourceset
        @cross_origin = cross_origin
      end

      def final_source_set
        return nil unless @sourceset.present?

        @sourceset.reduce({}) do |acc, item|
          acc[item[:source]] = item[:descriptor]

          acc
        end
      end
    end
  end
end
