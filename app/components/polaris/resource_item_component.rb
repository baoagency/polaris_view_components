# frozen_string_literal: true

module Polaris
  class ResourceItemComponent < Polaris::Component
    CURSOR_DEFAULT = :default
    CURSOR_OPTIONS = %i[default pointer]

    ALIGNMENT_DEFAULT = :default
    ALIGNMENT_MAPPINGS = {
      ALIGNMENT_DEFAULT => "",
      :center => "Polaris-ResourceItem--alignmentCenter"
    }
    ALIGNMENT_OPTIONS = ALIGNMENT_MAPPINGS.keys

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

    def initialize(
      url: nil,
      vertical_alignment: ALIGNMENT_DEFAULT,
      cursor: CURSOR_DEFAULT,
      selectable: false,
      selected: false,
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
      {
        tag: "div"
      }.deep_merge(@container_arguments).tap do |args|
        args[:classes] = class_names(
          args[:classes],
          "Polaris-ResourceItem__Container",
          ALIGNMENT_MAPPINGS[fetch_or_fallback(ALIGNMENT_OPTIONS, @vertical_alignment, ALIGNMENT_DEFAULT)]
        )
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
          "Polaris-ResourceItem--selected": @selected
        )
        prepend_option(args, :style, "cursor: #{@cursor};")
        prepend_option(args[:data], :action, "click->polaris-resource-item#open")
      end
    end

    def owned?
      checkbox.present? || radio_button.present? || media.present?
    end

    def owned_arguments
      {
        tag: "div",
        classes: class_names(
          "Polaris-ResourceItem__Owned",
          "Polaris-ResourceItem__OwnedNoMedia": media.blank?,
          "Polaris-ResourceItem__Owned--offset": @offset
        )
      }
    end

    private

    def cursor
      @url.present? ? "pointer" : "default"
    end
  end
end
