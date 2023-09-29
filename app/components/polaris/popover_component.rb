module Polaris
  class PopoverComponent < Polaris::Component
    ALIGNMENT_DEFAULT = :center
    ALIGNMENT_OPTIONS = [:left, :right, :center]

    POSITION_DEFAULT = :auto
    POSITION_OPTIONS = [:auto, :above, :below]

    renders_one :button, ->(**system_arguments) do
      system_arguments[:data] ||= {}
      prepend_option(system_arguments[:data], :action, "polaris-popover#toggle click@window->polaris-popover#hide")
      Polaris::ButtonComponent.new(**system_arguments)
    end
    renders_one :activator
    renders_many :panes, ->(**system_arguments) do
      Polaris::Popover::PaneComponent.new(scrollable_shadow: @scrollable_shadow, **system_arguments)
    end

    def initialize(
      active: false,
      inline: true,
      fixed: false,
      fluid_content: false,
      full_height: false,
      full_width: false,
      sectioned: false,
      alignment: ALIGNMENT_DEFAULT,
      position: POSITION_DEFAULT,
      append_to_body: false,
      scrollable_shadow: true,
      text_field_activator: false,
      wrapper_arguments: {},
      **system_arguments
    )
      @active = active
      @inline = inline
      @fixed = fixed
      @fluid_content = fluid_content
      @full_height = full_height
      @full_width = full_width
      @sectioned = sectioned
      @alignment = fetch_or_fallback(ALIGNMENT_OPTIONS, alignment, ALIGNMENT_DEFAULT)
      @position = fetch_or_fallback(POSITION_OPTIONS, position, POSITION_DEFAULT)
      @scrollable_shadow = scrollable_shadow
      @text_field_activator = text_field_activator
      @append_to_body = append_to_body
      @wrapper_arguments = wrapper_arguments
      @system_arguments = system_arguments
      @popover_arguments = {}
      @content_arguments = {}
    end

    def wrapper_arguments
      @wrapper_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] ||= {}
        prepend_option(opts[:data], :controller, "polaris-popover")
        opts[:data][:polaris_popover_append_to_body_value] = @append_to_body
        opts[:data][:polaris_popover_active_value] = @active
        opts[:data][:polaris_popover_placement_value] = popover_placement
        opts[:data][:polaris_popover_text_field_activator_value] = @text_field_activator
        opts[:data][:polaris_popover_open_class] = "Polaris-Popover__PopoverOverlay--open"
        opts[:data][:polaris_popover_closed_class] = "Polaris-Popover__PopoverOverlay--closed"
        if @inline
          prepend_option(opts, :style, "display: inline-block;")
        end
      end
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] ||= {}
        unless @append_to_body
          opts[:data]["polaris_popover_target"] = "popover"
        end
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-PositionedOverlay",
          "Polaris-Popover__PopoverOverlay",
          "Polaris-Popover__PopoverOverlay--closed",
          "Polaris-Popover__PopoverOverlay--fixed": @fixed
        )
      end
    end

    def popover_arguments
      @popover_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:classes] = class_names(
          @content_arguments[:classes],
          "Polaris-Popover",
          "Polaris-Popover--fullWidth": @full_width,
          "Polaris-Popover--positionedAbove": @position == :above
        )
      end
    end

    def content_arguments
      @content_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:tabindex] ||= "-1"
        opts[:classes] = class_names(
          @content_arguments[:classes],
          "Polaris-Popover__Content",
          "Polaris-Popover__Content--fluidContent": @fluid_content,
          "Polaris-Popover__Content--fullHeight": @full_height
        )
      end
    end

    def popover_placement
      placement =
        case @position
        when :above then "top"
        when :below then "bottom"
        else
          "bottom"
        end
      placement += "-start" if @alignment == :left
      placement += "-end" if @alignment == :right
      placement
    end
  end
end
