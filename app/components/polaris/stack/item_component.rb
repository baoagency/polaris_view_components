class Polaris::Stack::ItemComponent < Polaris::Component
  def initialize(fill: false, **system_arguments)
    @system_arguments = system_arguments
    @system_arguments[:tag] = "div"
    @system_arguments[:classes] = class_names(
      @system_arguments[:classes],
      "Polaris-LegacyStack__Item",
      "Polaris-LegacyStack__Item--fill": fill
    )
  end

  def call
    render(Polaris::BaseComponent.new(**@system_arguments)) { content }
  end
end
