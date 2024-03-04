# frozen_string_literal: true

module Polaris
  class HeadlessButton < Polaris::Component
    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      SIZE_DEFAULT => "",
      :slim => "Polaris-Button--sizeSlim",
      :large => "Polaris-Button--sizeLarge"
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    TEXT_ALIGN_DEFAULT = :default
    TEXT_ALIGN_MAPPINGS = {
      TEXT_ALIGN_DEFAULT => "",
      :left => "Polaris-Button--textAlignLeft",
      :center => "Polaris-Button--textAlignCenter",
      :right => "Polaris-Button--textAlignRight"
    }
    TEXT_ALIGN_OPTIONS = TEXT_ALIGN_MAPPINGS.keys

    DISCLOSURE_DEFAULT = false
    DISCLOSURE_OPTIONS = [true, false, :down, :up, :select, :horizontal_dots]

    renders_one :icon, IconComponent

    def initialize(
      url: nil,
      outline: false,
      plain: false,
      primary: false,
      pressed: false,
      monochrome: false,
      loading: false,
      destructive: false,
      disabled: false,
      disable_with_loader: false,
      disclosure: DISCLOSURE_DEFAULT,
      external: false,
      full_width: false,
      submit: false,
      remove_underline: false,
      size: SIZE_DEFAULT,
      text_align: TEXT_ALIGN_DEFAULT,
      icon_name: nil,
      **system_arguments
    )
      @tag = url.present? ? "a" : "button"
      @text_classes = class_names(
        "Polaris-Button__Text",
        "Polaris-Button--removeUnderline": plain && monochrome && remove_underline
      )
      @loading = loading
      @disclosure = fetch_or_fallback(DISCLOSURE_OPTIONS, disclosure, DISCLOSURE_DEFAULT)
      @disclosure = :down if @disclosure === true
      @icon_name = icon_name

      @system_arguments = system_arguments
      @system_arguments[:type] = submit ? "submit" : "button"
      if loading
        @system_arguments[:disabled] = true
      end
      if url.present?
        @system_arguments.delete(:type)
        @system_arguments[:href] = url
        @system_arguments[:target] = "_blank" if external
      end
      if disabled
        @system_arguments[:disabled] = disabled
      end
      @system_arguments[:data] ||= {}
      prepend_option(@system_arguments[:data], :controller, "polaris-button")
      if disable_with_loader
        prepend_option(@system_arguments[:data], :action, "polaris-button#disable")
      end
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Button",
        SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)],
        TEXT_ALIGN_MAPPINGS[fetch_or_fallback(TEXT_ALIGN_OPTIONS, text_align, TEXT_ALIGN_DEFAULT)],
        "Polaris-Button--destructive": destructive,
        "Polaris-Button--disabled": disabled || loading,
        "Polaris-Button--loading": loading,
        "Polaris-Button--fullWidth": full_width,
        "Polaris-Button--monochrome": monochrome,
        # "Polaris-Button--outline": outline,
        "Polaris-Button--plain": plain,
        "Polaris-Button--primary": primary,
        "Polaris-Button--pressed": pressed,
        "Polaris-Button--removeUnderline": plain && monochrome && remove_underline
      )
    end

    def system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Button--iconOnly": (icon.present? || @icon_name.present?) && content.blank?
      )
      @system_arguments
    end

    def html_options
      options = system_arguments
      options[:class] = options[:classes]
      options.delete(:classes)
      options
    end
  end
end
