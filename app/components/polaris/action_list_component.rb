module Polaris
  class ActionListComponent < Polaris::Component
    renders_many :items, Polaris::ActionList::ItemComponent
    renders_many :sections, ->(**system_arguments) do
      @counter += 1

      Polaris::ActionList::SectionComponent.new(
        position: @counter,
        multiple_sections: true,
        **system_arguments
      )
    end

    def initialize(**system_arguments)
      @counter = 0
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-ActionList"
        )
      end
    end
  end
end
