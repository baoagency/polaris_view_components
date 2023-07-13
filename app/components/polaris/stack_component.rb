# frozen_string_literal: true

module Polaris
  class StackComponent < Polaris::Component
    ALIGNMENT_DEFAULT = :default
    ALIGNMENT_MAPPINGS = {
      ALIGNMENT_DEFAULT => "",
      :leading => "Polaris-LegacyStack--alignmentLeading",
      :trailing => "Polaris-LegacyStack--alignmentTrailing",
      :center => "Polaris-LegacyStack--alignmentCenter",
      :fill => "Polaris-LegacyStack--alignmentFill",
      :baseline => "Polaris-LegacyStack--alignmentBaseline"
    }
    ALIGNMENT_OPTIONS = ALIGNMENT_MAPPINGS.keys

    DISTRIBUTION_DEFAULT = :default
    DISTRIBUTION_MAPPINGS = {
      DISTRIBUTION_DEFAULT => "",
      :equal_spacing => "Polaris-LegacyStack--distributionEqualSpacing",
      :leading => "Polaris-LegacyStack--distributionLeading",
      :trailing => "Polaris-LegacyStack--distributionTrailing",
      :center => "Polaris-LegacyStack--distributionCenter",
      :fill => "Polaris-LegacyStack--distributionFill",
      :fill_evenly => "Polaris-LegacyStack--distributionFillEvenly"
    }
    DISTRIBUTION_OPTIONS = DISTRIBUTION_MAPPINGS.keys

    SPACING_DEFAULT = :default
    SPACING_MAPPINGS = {
      SPACING_DEFAULT => "",
      :extra_tight => "Polaris-LegacyStack--spacingExtraTight",
      :tight => "Polaris-LegacyStack--spacingTight",
      :base_tight => "Polaris-LegacyStack--spacingBaseTight",
      :loose => "Polaris-LegacyStack--spacingLoose",
      :extra_loose => "Polaris-LegacyStack--spacingExtraLoose",
      :none => "Polaris-LegacyStack--spacingNone"
    }
    SPACING_OPTIONS = SPACING_MAPPINGS.keys

    renders_many :items, Polaris::Stack::ItemComponent

    def initialize(
      alignment: ALIGNMENT_DEFAULT,
      distribution: DISTRIBUTION_DEFAULT,
      spacing: SPACING_DEFAULT,
      vertical: false,
      wrap: true,
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-LegacyStack",
        ALIGNMENT_MAPPINGS[fetch_or_fallback(ALIGNMENT_OPTIONS, alignment, ALIGNMENT_DEFAULT)],
        DISTRIBUTION_MAPPINGS[fetch_or_fallback(DISTRIBUTION_OPTIONS, distribution, DISTRIBUTION_DEFAULT)],
        SPACING_MAPPINGS[fetch_or_fallback(SPACING_OPTIONS, spacing, SPACING_DEFAULT)],
        "Polaris-LegacyStack--vertical": vertical,
        "Polaris-LegacyStack--noWrap": !wrap
      )
    end
  end
end
