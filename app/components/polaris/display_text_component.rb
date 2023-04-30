# frozen_string_literal: true

module Polaris
  class DisplayTextComponent < Polaris::Component
    ELEMENT_DEFAULT = :p
    ELEMENT_OPTIONS = %i[p h1 h2 h3 h4 h5 h6]

    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      small: :headingLg,
      medium: :headingXl,
      large: :heading2xl,
      extra_large: :heading4xl
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    def initialize(
      element: ELEMENT_DEFAULT,
      size: SIZE_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments
      @element = element
      @variant = SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)]
    end

    def call
      render(Polaris::TextComponent.new(as: @element, variant: @variant, **@system_arguments)) { content }
    end
  end
end
