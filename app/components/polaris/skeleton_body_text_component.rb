# frozen_string_literal: true

module Polaris
  class SkeletonBodyTextComponent < Polaris::Component
    def initialize(lines: 3, **system_arguments)
      @lines = lines
      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-SkeletonBodyText__SkeletonBodyTextContainer"
      )
    end
  end
end
