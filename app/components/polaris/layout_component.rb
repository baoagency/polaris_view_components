module Polaris
  class LayoutComponent < Polaris::NewComponent
    # Required list of sections
    #
    # @param secondary [Boolean] The section will act like a sidebar
    # @param full_width [Boolean] The section will take up 100% of the width
    # @param one_half [Boolean] The section will only take up 50% of the width
    # @param one_third [Boolean] The section will only take up 33.33% of the width
    # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
    renders_many :sections, "LayoutSectionComponent"

    def initialize(sectioned: false, **system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        'Polaris-Layout'
      )
    end

    def render?
      sections.any?
    end

    class LayoutSectionComponent < Polaris::NewComponent
      def initialize(
        secondary: false,
        full_width: false,
        one_half: false,
        one_third: false,
        **system_arguments
      )
        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Layout__Section",
          "Polaris-Layout__Section--secondary" => secondary,
          "Polaris-Layout__Section--fullWidth" => full_width,
          "Polaris-Layout__Section--oneHalf" => one_half,
          "Polaris-Layout__Section--oneThird" => one_third,
        )
      end

      def call
        render(Polaris::BaseComponent.new(**@system_arguments)) { content }
      end
    end
  end
end
