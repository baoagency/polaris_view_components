# frozen_string_literal: true

module Polaris
  class TextStyleComponent < Polaris::Component
    VARIATION_OPTIONS = %i[positive negative strong subdued code]

    SIZE_DEFAULT = :default
    SIZE_MAPPINGS = {
      SIZE_DEFAULT => :bodyMd,
      :small => :bodySm
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    def initialize(
      variation: nil,
      size: SIZE_DEFAULT,
      **system_arguments
    )
      @variation = variation
      @system_arguments = system_arguments.tap do |opts|
        opts[:as] = :span
        opts[:color] = case variation
        when :subdued then :subdued
        when :positive then :success
        when :negative then :critical
        when :warning then :warning
        end
        opts[:font_weight] = case variation
        when :strong then :semibold
        end
        opts[:variant] = SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)]
      end
    end

    def call
      render(Polaris::TextComponent.new(**@system_arguments)) do
        if @variation == :code
          render(Polaris::InlineCodeComponent.new) { content }
        else
          content
        end
      end
    end
  end
end
