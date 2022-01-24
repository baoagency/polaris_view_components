# frozen_string_literal: true

module Polaris
  class CaptionComponent < Polaris::Component
    def initialize(**system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:tag] = "p"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Caption"
      )
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
