module Polaris
  class CardComponent
    class SectionComponent < Polaris::NewComponent
      renders_many :subsections, "Polaris::CardComponent::SubsectionComponent"

      def initialize(
        title: "",
        subdued: false,
        flush: false,
        full_width: false,
        actions: [],
        **system_arguments
      )
        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Card__Section",
          "Polaris-Card__Section--flush": flush,
          "Polaris-Card__Section--subdued": subdued,
          "Polaris-Card__Section--fullWidth": full_width,
        )

        @title = title
        @actions = actions.map { |a| a.merge(plain: true) }
      end
    end
  end
end
