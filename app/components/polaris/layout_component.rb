module Polaris
  class LayoutComponent < Polaris::NewComponent
    @@order = []

    # A list of sections
    #
    # @param secondary [Boolean] The section will act like a sidebar
    # @param full_width [Boolean] The section will take up 100% of the width
    # @param one_half [Boolean] The section will only take up 50% of the width
    # @param one_third [Boolean] The section will only take up 33.33% of the width
    # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
    renders_many :sections, "LayoutSectionComponent"

    # A list of annotated sections
    #
    # @param title [String] Title
    # @param description [String] Description
    # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
    renders_many :annotated_sections, "LayoutAnnotatedSectionComponent"

    def initialize(sectioned: false, **system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        'Polaris-Layout'
      )
    end

    def self.order
      @@order || []
    end
    def self.order=(val)
      @@order = val
    end

    def renderable_sections
      sections_index = -1
      annotated_index = -1

      renderables = LayoutComponent.order.map do |o|
        if o.class == LayoutSectionComponent
          sections[sections_index += 1]
        elsif o.class == LayoutAnnotatedSectionComponent
          annotated_sections[annotated_index += 1]
        end
      end

      LayoutComponent.order = []

      renderables
    end

    def render?
      sections.any? || annotated_sections.any?
    end

    class LayoutSectionComponent < Polaris::NewComponent
      def initialize(
        secondary: false,
        full_width: false,
        one_half: false,
        one_third: false,
        **system_arguments
      )
        LayoutComponent.order << self

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

    class LayoutAnnotatedSectionComponent < Polaris::NewComponent
      def initialize(title:, description: '', **system_arguments)
        LayoutComponent.order << self

        @title = title
        @description = description

        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Layout__AnnotatedSection"
        )
      end

      def call
        render(Polaris::BaseComponent.new(**@system_arguments)) do
          render(Polaris::BaseComponent.new(tag: :div, classes: "Polaris-Layout__AnnotationWrapper")) do
            ActionController::Base.helpers.safe_join([
              render(Polaris::BaseComponent.new(tag: :div, classes: "Polaris-Layout__Annotation")) do
                render(Polaris::TextContainer::Component.new) do
                  inner = [render(Polaris::HeadingComponent.new) { @title },]

                  if @description.present?
                    inner << render(Polaris::BaseComponent.new(tag: :div, classes: "Polaris-Layout__AnnotationDescription")) do
                      content_tag(:p, @description)
                    end
                  end

                  ActionController::Base.helpers.safe_join(inner)
                end
              end,

              render(Polaris::BaseComponent.new(tag: :div, classes: "Polaris-Layout__AnnotationContent")) { content }
            ])
          end
        end
      end
    end
  end
end
