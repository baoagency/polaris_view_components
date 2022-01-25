module Polaris
  class SkeletonThumbnailComponent < Polaris::Component
    SIZE_DEFAULT = :medium
    SIZE_MAPPINGS = {
      medium: "Polaris-SkeletonThumbnail--sizeMedium",
      large: "Polaris-SkeletonThumbnail--sizeLarge",
      small: "Polaris-SkeletonThumbnail--sizeSmall"
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
          "Polaris-SkeletonThumbnail",
          SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, @size, SIZE_DEFAULT)]
        )
      end
    end

    def call
      render(Polaris::BaseComponent.new(**system_arguments))
    end
  end
end
