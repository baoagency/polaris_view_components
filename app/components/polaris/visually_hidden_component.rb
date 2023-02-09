# frozen_string_literal: true

module Polaris
  class VisuallyHiddenComponent < Polaris::Component
    def call
      render(Polaris::TextComponent.new(as: :span, visually_hidden: true)) { content }
    end
  end
end
