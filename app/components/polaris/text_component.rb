# frozen_sting_literal: true

module Polaris
  class TextComponent < Polaris::Component
    include ActiveModel::Validations

    attr_reader :as, :variant, :alignment, :font_weight, :color

    AS_DEFAULT = :p
    AS_OPTIONS = %i[
      h1
      h2
      h3
      h4
      h5
      h6
      p
      span
      legend
    ]
    validates :as, inclusion: {in: AS_OPTIONS}

    VARIANT_DEFAULT = :bodyMd
    VARIANT_MAPPINGS = {
      headingXs: "Polaris-Text--headingXs",
      headingSm: "Polaris-Text--headingSm",
      headingMd: "Polaris-Text--headingMd",
      headingLg: "Polaris-Text--headingLg",
      headingXl: "Polaris-Text--headingXl",
      heading2xl: "Polaris-Text--heading2xl",
      heading3xl: "Polaris-Text--heading3xl",
      heading4xl: "Polaris-Text--heading4xl",
      bodySm: "Polaris-Text--bodySm",
      bodyMd: "Polaris-Text--bodyMd",
      bodyLg: "Polaris-Text--bodyLg"
    }
    VARIANT_OPTIONS = VARIANT_MAPPINGS.keys
    validates :variant, inclusion: {in: VARIANT_OPTIONS}

    ALIGNMENT_MAPPINGS = {
      start: "Polaris-Text--start",
      center: "Polaris-Text--center",
      end: "Polaris-Text--end",
      justify: "Polaris-Text--justify"
    }
    ALIGNMENT_OPTIONS = ALIGNMENT_MAPPINGS.keys
    validates :alignment, inclusion: {in: ALIGNMENT_OPTIONS}, allow_nil: true

    FONT_WEIGHT_MAPPINGS = {
      regular: "Polaris-Text--regular",
      medium: "Polaris-Text--medium",
      semibold: "Polaris-Text--semibold",
      bold: "Polaris-Text--bold"
    }
    FONT_WEIGHT_VARIANT_MAPPINGS = {
      headingXs: :semibold,
      headingSm: :semibold,
      headingMd: :semibold,
      headingLg: :semibold,
      headingXl: :semibold,
      heading2xl: :semibold,
      heading3xl: :semibold,
      heading4xl: :bold,
      bodySm: :regular,
      bodyMd: :regular,
      bodyLg: :regular
    }
    FONT_WEIGHT_OPTIONS = FONT_WEIGHT_MAPPINGS.keys
    validates :font_weight, inclusion: {in: FONT_WEIGHT_OPTIONS}, allow_nil: true

    COLOR_MAPPINGS = {
      success: "Polaris-Text--success",
      critical: "Polaris-Text--critical",
      warning: "Polaris-Text--warning",
      subdued: "Polaris-Text--subdued",
      text_inverse: "Polaris-Text__text--inverse"
    }
    COLOR_OPTIONS = COLOR_MAPPINGS.keys
    validates :color, inclusion: {in: COLOR_OPTIONS}, allow_nil: true

    def initialize(
      alignment: nil,
      as: AS_DEFAULT,
      break_word: false,
      color: nil,
      font_weight: nil,
      truncate: false,
      variant: VARIANT_DEFAULT,
      visually_hidden: false,
      **system_arguments
    )
      @system_arguments = system_arguments

      @alignment = alignment
      @color = color
      @font_weight = font_weight
      @variant = variant

      @system_arguments[:tag] = as || (visually_hidden ? :span : :p)
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Text--root",
        VARIANT_MAPPINGS[fetch_or_fallback(VARIANT_OPTIONS, variant, VARIANT_DEFAULT)],
        alignment_class,
        color_class,
        font_weight_class,
        "Polaris-Text--block": alignment || truncate,
        "Polaris-Text--break": break_word,
        "Polaris-Text--truncate": truncate,
        "Polaris-Text--visuallyHidden": visually_hidden
      )
    end

    def alignment_class
      return nil if @alignment.nil?

      ALIGNMENT_MAPPINGS[fetch_or_fallback(ALIGNMENT_OPTIONS, @alignment, ALIGNMENT_OPTIONS.first)]
    end

    def color_class
      return nil if @color.nil?

      COLOR_MAPPINGS[fetch_or_fallback(COLOR_OPTIONS, @color, COLOR_OPTIONS.first)]
    end

    def font_weight_class
      return FONT_WEIGHT_MAPPINGS[FONT_WEIGHT_VARIANT_MAPPINGS[@variant]] if @font_weight.nil?

      FONT_WEIGHT_MAPPINGS[fetch_or_fallback(FONT_WEIGHT_OPTIONS, @font_weight, FONT_WEIGHT_OPTIONS.first)]
    end
  end
end
