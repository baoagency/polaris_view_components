# frozen_string_literal: true

module Polaris
  class InlineCodeComponent < Polaris::Component
    def initialize(**system_arguments)
      @system_arguments = system_arguments.tap do |opts|
        opts[:tag] = "code"
        opts[:classes] = "Polaris-InlineCode__Code"
      end
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
