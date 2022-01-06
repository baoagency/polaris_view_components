# frozen_string_literal: true

module Polaris
  class StackComponent < Polaris::NewComponent
    ALIGNMENT_DEFAULT = :default
    ALIGNMENT_MAPPINGS = {
      ALIGNMENT_DEFAULT => "",
      :leading => "Polaris-Stack--alignmentLeading",
      :trailing => "Polaris-Stack--alignmentTrailing",
      :center => "Polaris-Stack--alignmentCenter",
      :fill => "Polaris-Stack--alignmentFill",
      :baseline => "Polaris-Stack--alignmentBaseline"
    }
    ALIGNMENT_OPTIONS = ALIGNMENT_MAPPINGS.keys

    DISTRIBUTION_DEFAULT = :default
    DISTRIBUTION_MAPPINGS = {
      DISTRIBUTION_DEFAULT => "",
      :equal_spacing => "Polaris-Stack--distributionEqualSpacing",
      :leading => "Polaris-Stack--distributionLeading",
      :trailing => "Polaris-Stack--distributionTrailing",
      :center => "Polaris-Stack--distributionCenter",
      :fill => "Polaris-Stack--distributionFill",
      :fill_evenly => "Polaris-Stack--distributionFillEvenly"
    }
    DISTRIBUTION_OPTIONS = DISTRIBUTION_MAPPINGS.keys

    SPACING_DEFAULT = :default
    SPACING_MAPPINGS = {
      SPACING_DEFAULT => "",
      :extra_tight => "Polaris-Stack--spacingExtraTight",
      :tight => "Polaris-Stack--spacingTight",
      :base_tight => "Polaris-Stack--spacingBaseTight",
      :loose => "Polaris-Stack--spacingLoose",
      :extra_loose => "Polaris-Stack--spacingExtraLoose",
      :none => "Polaris-Stack--spacingNone"
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
        "Polaris-Stack",
        ALIGNMENT_MAPPINGS[fetch_or_fallback(ALIGNMENT_OPTIONS, alignment, ALIGNMENT_DEFAULT)],
        DISTRIBUTION_MAPPINGS[fetch_or_fallback(DISTRIBUTION_OPTIONS, distribution, DISTRIBUTION_DEFAULT)],
        SPACING_MAPPINGS[fetch_or_fallback(SPACING_OPTIONS, spacing, SPACING_DEFAULT)],
        "Polaris-Stack--vertical": vertical,
        "Polaris-Stack--noWrap": !wrap
      )
    end
  end
end
