# frozen_string_literal: true

module Polaris
  class AlphaStackComponent < Polaris::Component
    AS_DEFAULT = :div
    AS_OPTIONS = %i[div ul ol fieldset]

    ALIGN_DEFAULT = :default
    ALIGN_MAPPINGS = {
      ALIGN_DEFAULT => "",
      :start => "start",
      :center => "center",
      :end => "end",
      :space_around => "space-around",
      :space_between => "space-between",
      :space_evenly => "space-evenly"
    }
    ALIGN_OPTIONS = ALIGN_MAPPINGS.keys

    INLINE_ALIGN_DEFAULT = :default
    INLINE_ALIGN_MAPPINGS = {
      INLINE_ALIGN_DEFAULT => "",
      :start => "start",
      :center => "center",
      :end => "end",
      :baseline => "baseline",
      :stretch => "stretch"
    }
    INLINE_ALIGN_OPTIONS = ALIGN_MAPPINGS.keys

    GAP_DEFAULT = nil
    GAP_OPTIONS = %w[0 025 05 1 2 3 4 5 6 8 10 12 16 20 24 28 32]

    def initialize(
      as: AS_DEFAULT,
      align: ALIGN_DEFAULT,
      inline_align: INLINE_ALIGN_DEFAULT,
      gap: GAP_DEFAULT,
      reverse_order: false,
      **system_arguments
    )
      @as = as
      @align = align
      @inline_align = inline_align
      @gap = gap
      @reverse_order = reverse_order
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = fetch_or_fallback(AS_OPTIONS, @as, AS_DEFAULT)
        opts[:classes] = class_names(
          opts[:classes],
          "Polaris-AlphaStack",
          "Polaris-listReset": @as.in?(%i[ul ol]),
          "Polaris-fieldsetReset": @as == :fieldset
        )
        opts[:style] = {
          "--pc-stack-align" => ALIGN_MAPPINGS[fetch_or_fallback(ALIGN_OPTIONS, @align, ALIGN_DEFAULT)],
          "--pc-stack-inline-align" => INLINE_ALIGN_MAPPINGS[fetch_or_fallback(INLINE_ALIGN_OPTIONS, @inline_align, INLINE_ALIGN_DEFAULT)],
          "--pc-stack-order" => @reverse_order ? "column-reverse" : "column",
          "--pc-stack-gap-xs" => "var(--p-space-#{fetch_or_fallback(GAP_OPTIONS, @gap, GAP_DEFAULT)})"
        }
          .reject { |_, v| v.blank? }
          .merge(opts[:style] || {})
          .map { |k, v| "#{k}: #{v}" }
          .join(";")
      end
    end

    def call
      render(Polaris::BaseComponent.new(**system_arguments)) { content }
    end
  end
end
