class Polaris::Popover::PaneComponent < Polaris::Component
  renders_many :sections, Polaris::Popover::SectionComponent

  def initialize(
    fixed: false,
    sectioned: false,
    capture_overscroll: false,
    height: nil,
    scrollable_shadow: true,
    **system_arguments
  )
    @fixed = fixed
    @sectioned = sectioned
    @capture_overscroll = capture_overscroll
    @height = height
    @scrollable_shadow = scrollable_shadow
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |args|
      args[:tag] = "div"
      args[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Popover__Pane",
        "Polaris-Popover__Pane--fixed": @fixed,
        "Polaris-Popover__Pane--captureOverscroll": @capture_overscroll
      )
      args[:style] = styles_list(
        args[:style],
        height: @height,
        max_height: @height,
        min_height: @height
      )
    end
  end
end
