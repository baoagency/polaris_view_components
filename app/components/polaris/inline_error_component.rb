# frozen_string_literal: true

module Polaris
  class InlineErrorComponent < Polaris::NewComponent
    def initialize
    end

    def renders?
      content.present?
    end
  end
end
