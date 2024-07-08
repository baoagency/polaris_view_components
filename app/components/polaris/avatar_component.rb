# frozen_string_literal: true

module Polaris
  class AvatarComponent < Polaris::Component
    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      extra_small: "Polaris-Avatar--sizeExtraSmall",
      small: "Polaris-Avatar--sizeSmall",
      medium: "Polaris-Avatar--sizeMedium",
      large: "Polaris-Avatar--sizeLarge"
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    SHAPE_DEFAULT = :round
    SHAPE_MAPPINGS = {
      square: "Polaris-Avatar--shapeSquare",
      round: "Polaris-Avatar--shapeRound"
    }
    SHAPE_OPTIONS = SHAPE_MAPPINGS.keys

    STYLE_CLASSES = %w[styleOne styleTwo styleThree styleFour styleFive]

    def initialize(
      customer: false,
      initials: nil,
      name: nil,
      size: SIZE_DEFAULT,
      shape: SHAPE_DEFAULT,
      source: nil,
      icon: nil,
      **system_arguments
    )
      @customer = customer
      @initials = initials
      @name = name
      @size = size
      @shape = shape
      @source = source
      @icon = icon
      @system_arguments = system_arguments
    end

    def style_class
      if @name.present?
        STYLE_CLASSES[xor_hash(@name) % STYLE_CLASSES.length]
      else
        STYLE_CLASSES.first
      end
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "span"
        opts[:role] = "img"
        if @name
          opts[:aria] ||= {}
          opts[:aria][:label] ||= @name
        end
        opts[:classes] = class_names(
          opts[:classes],
          "Polaris-Avatar",
          SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, @size, SIZE_DEFAULT)],
          SHAPE_MAPPINGS[fetch_or_fallback(SHAPE_OPTIONS, @shape, SHAPE_DEFAULT)],
          "Polaris-Avatar--#{style_class}" => !@customer && !@source
        )
      end
    end

    def xor_hash(string)
      string.bytes.reduce(0) { |hash, byte| hash ^ byte }
    end
  end
end
