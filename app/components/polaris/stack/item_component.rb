class Polaris::Stack::ItemComponent < Polaris::NewComponent
  def initialize(fill: false, **system_arguments)
    @system_arguments = system_arguments
    @system_arguments[:tag] = "div"
    @system_arguments[:classes] = class_names(
      @system_arguments[:classes],
      "Polaris-Stack__Item",
      "Polaris-Stack__Item--fill": fill
    )
  end

  def call
    render(Polaris::BaseComponent.new(**@system_arguments)) { content }
  end
end
