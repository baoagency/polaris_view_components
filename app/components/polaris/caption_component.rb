# frozen_string_literal: true

module Polaris
  class CaptionComponent < Polaris::Component
    def initialize(**system_arguments)
      @system_arguments = system_arguments
    end

    def call
      render(Polaris::TextComponent.new(as: :p, variant: :bodySm, **@system_arguments)) { content }
    end
  end
end
