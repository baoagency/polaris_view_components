# frozen_string_literal: true

module Polaris
  class KeyboardKeyComponent < Polaris::Component
    def initialize(**system_arguments)
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:classes] = class_names(opts[:classes], "Polaris-KeyboardKey")
      end
    end

    def call
      render(Polaris::BaseComponent.new(**system_arguments)) { content }
    end
  end
end
