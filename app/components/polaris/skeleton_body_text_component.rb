# frozen_string_literal: true

module Polaris
  class SkeletonBodyTextComponent < Polaris::Component
    def initialize(lines: 3)
      @lines = lines
    end
  end
end
