module Polaris
  class NavigationComponent < Polaris::Component
    renders_many :sections, Polaris::Navigation::SectionComponent
    renders_many :items, Polaris::Navigation::ItemComponent

    def initialize(logo: nil, **system_arguments)
      @logo = logo.is_a?(Hash) ? Polaris::Logo.new(**logo) : logo
      @system_arguments = system_arguments
    end

    def renders?
      sections.any? || items.any?
    end
  end
end
