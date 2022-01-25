module Polaris
  class SkeletonDisplayTextComponent < Polaris::Component
    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      small: "Polaris-SkeletonDisplayText--sizeSmall",
      medium: "Polaris-SkeletonDisplayText--sizeMedium",
      large: "Polaris-SkeletonDisplayText--sizeLarge",
      extra_large: "Polaris-SkeletonDisplayText--sizeExtraLarge"
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys

    def initialize(size: SIZE_DEFAULT, **system_arguments)
      @size = size
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-SkeletonDisplayText__DisplayText",
          SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, @size, SIZE_DEFAULT)]
        )
      end
    end

    def call
      render(Polaris::BaseComponent.new(**system_arguments))
    end
  end
end
