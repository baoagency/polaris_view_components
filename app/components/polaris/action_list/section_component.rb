class Polaris::ActionList::SectionComponent < Polaris::NewComponent
  renders_many :items, Polaris::ActionList::ItemComponent

  def initialize(position: 1, title: nil, **system_arguments)
    @position = position
    @title = title
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "div"
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ActionList__Section--withoutTitle": @title.blank?
      )
    end
  end

  def title_classes
    class_names(
      "Polaris-ActionList__Title",
      "Polaris-ActionList--firstSectionWithTitle": @position == 1
    )
  end
end
