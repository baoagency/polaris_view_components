module Polaris
  class PopoverComponent < Polaris::NewComponent
    ALIGNMENT_DEFAULT = :center
    ALIGNMENT_OPTIONS = [:left, :right, :center]

    POSITION_DEFAULT = :below
    POSITION_OPTIONS = [:above, :below]

    renders_one :button, -> (**system_arguments) do
      system_arguments[:data] ||= {}
      prepend_option(system_arguments[:data], :action, "polaris-popover#toggle click@window->polaris-popover#hide")
      Polaris::ButtonComponent.new(**system_arguments)
    end
    renders_one :activator
    renders_many :panes, Polaris::Popover::PaneComponent

    def initialize(
      active: false,
      fixed: false,
      fluid_content: false,
      full_height: false,
      full_width: false,
      sectioned: false,
      alignment: ALIGNMENT_DEFAULT,
      position: POSITION_DEFAULT,
      **system_arguments
    )
      @active = active
      @fixed = fixed
      @fluid_content = fluid_content
      @full_height = full_height
      @full_width = full_width
      @sectioned = sectioned
      @alignment = fetch_or_fallback(ALIGNMENT_OPTIONS, alignment, ALIGNMENT_DEFAULT)
      @position = fetch_or_fallback(POSITION_OPTIONS, position, POSITION_DEFAULT)
      @system_arguments = system_arguments
      @popover_arguments = {}
      @content_arguments = {}
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:data] ||= {}
        opts[:data]["polaris_popover_target"] = "popover"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-PositionedOverlay",
          "Polaris-Popover__PopoverOverlay",
          "Polaris-Popover__PopoverOverlay--closed",
          "Polaris-Popover__PopoverOverlay--fixed": @fixed,
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
          "Polaris-Popover--positionedAbove": @position == :above,
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
          "Polaris-Popover__Content--fullHeight": @full_height,
        )
      end
    end

    def popperjs_placement
      placement = (@position == :above) ? "top" : "bottom"
      placement += "-start" if @alignment == :left
      placement += "-end" if @alignment == :right
      placement
    end
  end
end
