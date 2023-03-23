# frozen_string_literal: true

module Polaris
  class FooterHelpComponent < Polaris::Component
    def initialize(**system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-FooterHelp"
      )
    end
  end
end
