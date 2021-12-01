module Polaris
  class NavigationComponent < Polaris::NewComponent
    renders_many :sections, Polaris::Navigation::SectionComponent
    renders_many :items, Polaris::Navigation::ItemComponent

    def initialize(**system_arguments)
      @system_arguments = system_arguments
    end

    def renders?
      sections.any? || items.any?
    end
  end
end
