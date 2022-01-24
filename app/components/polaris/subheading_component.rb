# frozen_string_literal: true

module Polaris
  class SubheadingComponent < Polaris::Component
    ELEMENT_DEFAULT = :h3
    ELEMENT_OPTIONS = %i[p h1 h2 h3 h4 h5 h6]

    def initialize(
      element: ELEMENT_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = element
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Subheading"
      )
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
