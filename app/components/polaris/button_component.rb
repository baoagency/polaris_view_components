# frozen_string_literal: true

module Polaris
  class ButtonComponent < Polaris::NewComponent
    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      SIZE_DEFAULT => "",
      :slim => "Polaris-Button--sizeSlim",
      :large => "Polaris-Button--sizeLarge",
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    TEXT_ALIGN_DEFAULT = :default
    TEXT_ALIGN_MAPPINGS = {
      TEXT_ALIGN_DEFAULT => "",
      :left => "Polaris-Button--textAlignLeft",
      :center => "Polaris-Button--textAlignCenter",
      :right => "Polaris-Button--textAlignRight",
    }
    TEXT_ALIGN_OPTIONS = TEXT_ALIGN_MAPPINGS.keys

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
      external: false,
      full_width: false,
      submit: false,
      remove_underline: false,
      size: SIZE_DEFAULT,
      text_align: TEXT_ALIGN_DEFAULT,
      **system_arguments
    )
      @tag = url.present? ? 'a' : 'button'
      @text_classes = class_names(
        "Polaris-Button__Text",
        "Polaris-Button--removeUnderline": plain && monochrome && remove_underline
      )
      @loading = loading

      @system_arguments = system_arguments
      @system_arguments[:type] = submit ? 'submit' : 'button'
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
        "Polaris-Button--outline": outline,
        "Polaris-Button--plain": plain,
        "Polaris-Button--primary": primary,
        "Polaris-Button--pressed": pressed,
        "Polaris-Button--removeUnderline": (plain && monochrome && remove_underline)
      )
    end

    private

    def dynamic_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Button--iconOnly": icon.present? && content.blank?,
      )
      @system_arguments
    end
  end
end
