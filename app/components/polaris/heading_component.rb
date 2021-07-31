# frozen_string_literal: true

module Polaris
  class HeadingComponent < Polaris::NewComponent
    ELEMENT_DEFAULT = :h2
    ELEMENT_OPTIONS = %w[p h1 h2 h3 h4 h5 h6]

    def initialize(
      element: ELEMENT_DEFAULT,
      **system_arguments
    )
      @element = element

      @system_arguments = system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        'Polaris-Heading'
      )
    end
  end
end
