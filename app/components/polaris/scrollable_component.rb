# frozen_string_literal: true

module Polaris
  class ScrollableComponent < Polaris::Component
    def initialize(
      height: nil,
      width: nil,
      vertical: true,
      horizontal: false,
      shadow: false,
      focusable: false,
      **system_arguments
    )
      @height = height
      @width = width
      @vertical = vertical
      @horizontal = horizontal
      @shadow = shadow
      @focusable = focusable
      @system_arguments = system_arguments
    end

    def system_arguments
      {
        tag: "div",
        data: {
          polaris_scrollable_shadow_value: @shadow,
          polaris_scrollable_top_shadow_class: "Polaris-Scrollable--hasTopShadow",
          polaris_scrollable_bottom_shadow_class: "Polaris-Scrollable--hasBottomShadow"
        }
      }.deep_merge(@system_arguments).tap do |opts|
        prepend_option(opts[:data], :controller, "polaris-scrollable")
        opts[:tabindex] = "0" if @focusable
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Scrollable",
          "Polaris-Scrollable--horizontal" => @horizontal,
          "Polaris-Scrollable--vertical" => @vertical
        )
        opts[:style] = class_names(
          @system_arguments[:style],
          "height: #{@height};" => @height.present?,
          "width: #{@width};" => @width.present?
        )
      end
    end
  end
end
