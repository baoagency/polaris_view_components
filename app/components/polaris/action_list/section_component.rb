class Polaris::ActionList::SectionComponent < Polaris::Component
  renders_many :items, Polaris::ActionList::ItemComponent

  def initialize(
    position: 1,
    multiple_sections: false,
    title: nil,
    **system_arguments
  )
    @position = position
    @multiple_sections = multiple_sections
    @title = title
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "div"
    end
  end
end
