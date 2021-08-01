# frozen_string_literal: true

module Polaris
  class LayoutComponent < Polaris::NewComponent
    # A list of sections
    #
    # @param secondary [Boolean] The section will act like a sidebar
    # @param full_width [Boolean] The section will take up 100% of the width
    # @param one_half [Boolean] The section will only take up 50% of the width
    # @param one_third [Boolean] The section will only take up 33.33% of the width
    # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
    renders_many :sections, -> (**system_arguments) do
      @counter += 1
      Layout::Section.new(position: @counter, **system_arguments)
    end

    # A list of annotated sections
    #
    # @param title [String] Title
    # @param description [String] Description
    # @param system_arguments [Hash] <%= link_to_system_arguments_docs %>
    renders_many :annotated_sections, -> (**system_arguments) do
      @counter += 1
      Layout::AnnotatedSection.new(position: @counter, **system_arguments)
    end

    def initialize(sectioned: false, **system_arguments)
      @counter = 0
      @system_arguments = system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        'Polaris-Layout'
      )
    end

    def all_sections
      @all_sections ||= sections + annotated_sections
    end

    def ordered_sections
      all_sections.sort_by(&:position)
    end

    def render?
      all_sections.any?
    end
  end
end
