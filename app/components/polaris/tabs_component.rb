module Polaris
  class TabsComponent < Polaris::Component
    renders_many :tabs, Polaris::Tabs::TabComponent

    def initialize(fitted: false, wrapper_arguments: {}, **system_arguments)
      @fitted = fitted
      @wrapper_arguments = wrapper_arguments
      @system_arguments = system_arguments
    end

    def wrapper_arguments
      @wrapper_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:classes] = class_names(
          @wrapper_arguments[:classes],
          "Polaris-LegacyTabs__Wrapper"
        )
      end
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "ul"
        opts[:role] = "tablist"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-LegacyTabs",
          "Polaris-LegacyTabs--fitted": @fitted
        )
      end
    end

    def renders?
      tabs.present?
    end
  end
end
