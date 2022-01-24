class Polaris::FormLayout::ItemComponent < Polaris::Component
  attr_reader :position

  def initialize(position:, **system_arguments)
    @position = position

    @system_arguments = system_arguments
    @system_arguments[:tag] = "div"
    @system_arguments[:classes] = class_names(
      @system_arguments[:classes],
      "Polaris-FormLayout__Item"
    )
  end

  def call
    render(Polaris::BaseComponent.new(**@system_arguments)) { content }
  end
end
