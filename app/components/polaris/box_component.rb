module Polaris
  class BoxComponent < Polaris::Component
    AS_DEFAULT = :div
    AS_OPTIONS = %i[div span section legend ul li]

    LINE_STYLES = %i[solid dashed]
    OVERFLOW_OPTIONS = %i[hidden scroll]
    POSITION_OPTIONS = %i[relative absolute fixed sticky]
    ROLE_OPTIONS = %i[status presentation menu listbox combobox]

    def initialize(
      as: AS_DEFAULT,
      background: nil,
      border_color: "transparent",
      border_style: nil,
      border_radius: nil,
      border_radius_end_start: nil,
      border_radius_end_end: nil,
      border_radius_start_start: nil,
      border_radius_start_end: nil,
      border_width: nil,
      border_block_start_width: nil,
      border_block_end_width: nil,
      border_inline_start_width: nil,
      border_inline_end_width: nil,
      color: nil,
      min_height: nil,
      min_width: nil,
      max_width: nil,
      overflow_x: nil,
      overflow_y: nil,
      padding: nil,
      padding_block_start: nil,
      padding_block_end: nil,
      padding_inline_start: nil,
      padding_inline_end: nil,
      role: nil,
      shadow: nil,
      width: nil,
      position: nil,
      inset_block_start: nil,
      inset_block_end: nil,
      inset_inline_start: nil,
      inset_inline_end: nil,
      opacity: nil,
      outline_color: nil,
      outline_style: nil,
      outline_width: nil,
      print_hidden: false,
      visually_hidden: false,
      z_index: nil,
      **system_arguments
    )
      @system_arguments = system_arguments.tap do |args|
        args[:tag] = fetch_or_fallback(AS_OPTIONS, as, AS_DEFAULT)
        args[:role] = role_value(role)
        args[:classes] = class_names(
          args[:classes],
          "Polaris-Box",
          "Polaris-Box--visuallyHidden": visually_hidden,
          "Polaris-Box--printHidden": print_hidden,
          "Polaris-Box--listReset": as == :ul
        )
        args[:style] = styles_list(
          args[:style],
          "--pc-box-color": color_value(color),
          "--pc-box-background": background_value(background),
          "--pc-box-border-color": (border_color == "transparent") ? "transparent" : border_color_value(border_color),
          "--pc-box-border-style": style_value(border_style, border_color, border_width, border_block_start_width, border_block_end_width, border_inline_start_width, border_inline_end_width),
          "--pc-box-border-radius": border_radius_value(border_radius),
          "--pc-box-border-radius-end-start": border_radius_value(border_radius_end_start),
          "--pc-box-border-radius-end-end": border_radius_value(border_radius_end_end),
          "--pc-box-border-radius-start-start": border_radius_value(border_radius_start_start),
          "--pc-box-border-radius-start-end": border_radius_value(border_radius_start_end),
          "--pc-box-border-width": border_width_value(border_width),
          "--pc-box-border-block-start-width": border_width_value(border_block_start_width),
          "--pc-box-border-block-end-width": border_width_value(border_block_end_width),
          "--pc-box-border-inline-start-width": border_width_value(border_inline_start_width),
          "--pc-box-border-inline-end-width": border_width_value(border_inline_end_width),
          "--pc-box-min-height": min_height,
          "--pc-box-min-width": min_width,
          "--pc-box-max-width": max_width,
          "--pc-box-outline-color": border_color_value(outline_color),
          "--pc-box-outline-style": style_value(outline_style, outline_color, outline_width),
          "--pc-box-outline-width": border_width_value(outline_width),
          "--pc-box-overflow-x": overflow_value(overflow_x),
          "--pc-box-overflow-y": overflow_value(overflow_y),
          **padding_value("block-end", padding_block_end || padding),
          **padding_value("block-start", padding_block_start || padding),
          **padding_value("inline-end", padding_inline_end || padding),
          **padding_value("inline-start", padding_inline_start || padding),
          "--pc-box-shadow": shadow_value(shadow),
          "--pc-box-width": width,
          position: position_value(position),
          "--pc-box-inset-block-start": space_value(inset_block_start),
          "--pc-box-inset-block-end": space_value(inset_block_end),
          "--pc-box-inset-inline-start": space_value(inset_inline_start),
          "--pc-box-inset-inline-end": space_value(inset_inline_end),
          "z-index": z_index,
          opacity: opacity
        )
      end
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end

    private

    def role_value(role)
      return unless role
      fetch_or_fallback(ROLE_OPTIONS, role)
    end

    def color_value(color)
      return unless color
      "var(--p-color-#{fetch_or_fallback(Tokens::Color::TEXT_ALIAS, color)})"
    end

    def background_value(background)
      return unless background
      "var(--p-color-#{fetch_or_fallback(Tokens::Color::BACKGROUND_ALIAS, background)})"
    end

    def border_color_value(border_color)
      return unless border_color
      "var(--p-color-#{fetch_or_fallback(Tokens::Color::BORDER_ALIAS, border_color)})"
    end

    def style_value(style, *args)
      if style
        fetch_or_fallback(LINE_STYLES, style)
      else
        args.compact.any? ? "solid" : nil
      end
    end

    def border_radius_value(border_radius)
      return unless border_radius
      "var(--p-border-radius-#{fetch_or_fallback(Tokens::Border::RADIUS_SCALE, border_radius)})"
    end

    def border_width_value(border_width)
      return unless border_width
      "var(--p-border-width-#{fetch_or_fallback(Tokens::Border::WIDTH_SCALE, border_width)})"
    end

    def overflow_value(overflow)
      return unless overflow
      fetch_or_fallback(OVERFLOW_OPTIONS, overflow)
    end

    def shadow_value(shadow)
      return unless shadow
      "var(--p-shadow-#{fetch_or_fallback(Tokens::Shadow::ALIAS, shadow)})"
    end

    def position_value(position)
      return unless position
      fetch_or_fallback(POSITION_OPTIONS, position)
    end

    def space_value(space)
      return unless space
      "var(--p-space-#{fetch_or_fallback(Tokens::Spacing::SCALE, space)})"
    end

    def padding_value(property, pagging)
      return {} unless pagging

      value = fetch_or_fallback_nested(
        Tokens::Spacing::SCREEN_SIZES,
        Tokens::Spacing::SCALE,
        pagging
      )

      if value.is_a?(Hash)
        value.each_with_object({}) do |(key, value), hash|
          hash["--pc-box-padding-#{property}-#{key}"] = "var(--p-space-#{value})"
        end
      else
        {"--pc-box-padding-#{property}-xs": "var(--p-space-#{value})"}
      end
    end
  end
end
