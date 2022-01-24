class Polaris::Popover::PaneComponent < Polaris::Component
  renders_many :sections, Polaris::Popover::SectionComponent

  def initialize(fixed: false, sectioned: false, **system_arguments)
    @fixed = fixed
    @sectioned = sectioned
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "div"
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Popover__Pane",
        "Polaris-Popover__Pane--fixed": @fixed
      )
    end
  end
end
