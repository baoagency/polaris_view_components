module Polaris
  class TooltipComponent < Polaris::Component
    POSITION_OPTIONS = [:top, :bottom, :left, :right]
    DEFAULT_POSITION = :bottom
    DEFAULT_PADDING = 4

    def initialize(
      text: nil,
      position: DEFAULT_POSITION,
      active: true,
      **system_arguments
    )
      @text = text
      @system_arguments = system_arguments
      @position = fetch_or_fallback(POSITION_OPTIONS, position, DEFAULT_POSITION)
      @active = active

      system_arguments[:data] ||= {}
      prepend_option(system_arguments[:data], :polaris_tooltip_active_value, @active)
      prepend_option(system_arguments[:data], :polaris_tooltip_position_value, @position)
      prepend_option(
        system_arguments[:data],
        :action,
        "mouseenter->polaris-tooltip#show mouseleave->polaris-tooltip#hide"
      )
      prepend_option(system_arguments[:data], :controller, "polaris-tooltip")
    end
  end
end
