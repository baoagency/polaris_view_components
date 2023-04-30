# frozen_string_literal: true

module Polaris
  class InlineComponent < Polaris::Component
    include ActiveModel::Validations

    attr_reader :align, :block_align, :gap, :wrap

    ALIGN_DEFAULT = :start
    ALIGN_OPTIONS = %i[start center end space-around space-between space-evenly]
    validates :align, inclusion: {in: ALIGN_OPTIONS}

    BLOCK_ALIGN_DEFAULT = :center
    BLOCK_ALIGN_OPTIONS = %i[start center end baseline stretch]
    validates :block_align, inclusion: {in: BLOCK_ALIGN_OPTIONS}

    GAP_DEFAULT = 4
    validates :gap, inclusion: {in: Polaris::Tokens::Spacing::SCALE}

    WRAP_DEFAULT = true
    validates :wrap, inclusion: {in: [true, false]}

    def initialize(
      align: ALIGN_DEFAULT,
      block_align: BLOCK_ALIGN_DEFAULT,
      gap: GAP_DEFAULT,
      wrap: WRAP_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments

      @system_arguments[:tag] = :div
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Inline"
      )
      @system_arguments[:style] = "--pc-inline-align: #{align}; --pc-inline-block-align: #{block_align}; --pc-inline-wrap: #{wrap ? :wrap : :nowrap}; --pc-inline-gap-xs: var(--p-space-#{gap})"
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
