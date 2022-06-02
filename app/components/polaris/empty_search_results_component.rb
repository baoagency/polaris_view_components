module Polaris
  class EmptySearchResultsComponent < Polaris::Component
    def initialize(title:, description:, **system_arguments)
      @title = title
      @description = description
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |args|
        args[:tag] = "div"
        args[:classes] = class_names(
          args[:classes],
          "Polaris-EmptySearchResults"
        )
      end
    end
  end
end
