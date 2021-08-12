# frozen_string_literal: true

module Polaris
  class ResourceListComponent < Polaris::NewComponent
    def initialize(
      wrapper_arguments: {},
      **system_arguments
    )
      @wrapper_arguments = wrapper_arguments
      @wrapper_arguments[:tag] = "div"
      @wrapper_arguments[:classes] = class_names(
        @wrapper_arguments[:classes],
        "Polaris-ResourceList__ResourceListWrapper",
      )

      @system_arguments = system_arguments
      @system_arguments[:tag] = "ul"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ResourceList",
      )
    end

    def call
      render(Polaris::BaseComponent.new(**@wrapper_arguments)) do
        render(Polaris::BaseComponent.new(**@system_arguments)) do
          content
        end
      end
    end
  end
end
