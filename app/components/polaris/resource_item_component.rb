# frozen_string_literal: true

module Polaris
  class ResourceItemComponent < Polaris::Component
    CURSOR_DEFAULT = :default
    CURSOR_OPTIONS = %i[default pointer]

    renders_one :checkbox, ->(**system_arguments) do
      Polaris::CheckboxComponent.new(
        label_hidden: true,
        **system_arguments
      )
    end
    renders_one :radio_button, ->(**system_arguments) do
      Polaris::RadioButtonComponent.new(
        label_hidden: true,
        **system_arguments
      )
    end
    renders_one :media

    renders_one :shortcut_actions, ->(**system_arguments) do
      Polaris::ResourceItem::ShortcutActionsComponent.new(
        persist_actions: @persist_actions,
        **system_arguments
      )
    end

    def initialize(
      url: nil,
      vertical_alignment: nil,
      cursor: CURSOR_DEFAULT,
      selectable: false,
      selected: false,
      persist_actions: false,
      offset: false,
      wrapper_arguments: {},
      container_arguments: {},
      **system_arguments
    )
      @url = url
      @vertical_alignment = vertical_alignment
      @cursor = fetch_or_fallback(CURSOR_OPTIONS, cursor, CURSOR_DEFAULT)
      @selectable = selectable
      @selected = selected
      @persist_actions = persist_actions
      @offset = offset
      @wrapper_arguments = wrapper_arguments
      @container_arguments = container_arguments
      @system_arguments = system_arguments
    end

    def wrapper_arguments
      {
        tag: "li",
        data: {}
      }.deep_merge(@wrapper_arguments).tap do |args|
        args[:classes] = class_names(
          args[:classes],
          "Polaris-ResourceItem__ListItem"
        )
        prepend_option(args[:data], :controller, "polaris-resource-item")
      end
    end

    def container_arguments
      @container_arguments.tap do |args|
        args[:classes] = class_names(
          args[:classes]
        )
        args[:position] = :relative
        args[:padding] = "3"
        args[:z_index] = "var(--pc-resource-item-content-stacking-order)"
      end
    end

    def system_arguments
      {
        tag: "div",
        data: {}
      }.deep_merge(@system_arguments).tap do |args|
        args[:classes] = class_names(
          args[:classes],
          "Polaris-ResourceItem",
          "Polaris-ResourceItem--selectable": @selectable,
          "Polaris-ResourceItem--selected": @selected,
          "Polaris-ResourceItem--persistActions": @persist_actions
        )
        prepend_option(args, :style, "cursor: #{@cursor};")
        prepend_option(args[:data], :action, "click->polaris-resource-item#open")
      end
    end

    def owned?
      checkbox.present? || radio_button.present? || media.present?
    end

    private

    def cursor
      @url.present? ? "pointer" : "default"
    end
  end
end
