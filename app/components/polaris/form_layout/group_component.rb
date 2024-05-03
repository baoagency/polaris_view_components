class Polaris::FormLayout::GroupComponent < Polaris::Component
  attr_reader :position

  renders_many :items, "GroupItemComponent"

  def initialize(position:, condensed: false, wrapper_arguments: {}, **system_arguments)
    @position = position

    @system_arguments = system_arguments
    @system_arguments[:tag] = "div"
    @system_arguments[:classes] = class_names(
      @system_arguments[:classes],
      "Polaris-FormLayout__Items"
    )

    @wrapper_arguments = wrapper_arguments
    @wrapper_arguments[:tag] = "div"
    @wrapper_arguments[:role] = "group"
    @wrapper_arguments[:classes] = class_names(
      "Polaris-FormLayout--grouped": !condensed,
      "Polaris-FormLayout--condensed": condensed
    )
  end

  class GroupItemComponent < Polaris::Component
    def initialize(**system_arguments)
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
end
