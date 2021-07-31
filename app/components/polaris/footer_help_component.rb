# frozen_string_literal: true

module Polaris
  class FooterHelpComponent < Polaris::NewComponent
    def initialize(**system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-FooterHelp",
      )
    end
  end
end
