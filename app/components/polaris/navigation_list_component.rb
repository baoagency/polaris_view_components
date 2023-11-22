module Polaris
  class NavigationListComponent < Polaris::Component
    renders_many :items, Polaris::Navigation::ItemComponent

    def initialize(**system_arguments)
      @system_arguments = system_arguments
    end

    def renders?
      items.any?
    end
  end
end
