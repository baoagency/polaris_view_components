# frozen_string_literal: true

module Polaris
  class SkeletonPageComponent < Polaris::Component
    def initialize(title: nil, primary_action: false, **system_arguments)
      @title = title
      @primary_action = primary_action
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:role] = "status"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-SkeletonPage__Page"
        )
      end
    end
  end
end
