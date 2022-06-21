module Polaris
  class EmptySearchResultsComponent < Polaris::Component
    renders_one :image

    def initialize(title:, description: nil, **system_arguments)
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
