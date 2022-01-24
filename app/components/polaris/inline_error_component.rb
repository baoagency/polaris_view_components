# frozen_string_literal: true

module Polaris
  class InlineErrorComponent < Polaris::Component
    def initialize(**system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-InlineError"
      )
    end

    def renders?
      content.present?
    end
  end
end
