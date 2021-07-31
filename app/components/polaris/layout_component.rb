module Polaris
  class LayoutComponent < Polaris::NewComponent
    # Required list of sections
    #
    # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
    renders_many :sections, "LayoutSectionComponent"

    def initialize(sectioned: false, **system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        'Polaris-Layout'
      )
    end

    def before_render
      puts 'b4', content
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

        puts 'kontent', content, full_width
      end

      def call
        render(Polaris::BaseComponent.new(**@system_arguments)) { content }
      end
    end
  end
end
