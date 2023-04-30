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
      @element = element
    end

    def call
      render(Polaris::TextComponent.new(as: @element, variant: :headingXs, **@system_arguments)) { content }
    end
  end
end
