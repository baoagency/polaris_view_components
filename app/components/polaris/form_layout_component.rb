# frozen_string_literal: true

module Polaris
  class FormLayoutComponent < Polaris::Component
    renders_many :items, ->(**system_arguments) do
      @counter += 1
      Polaris::FormLayout::ItemComponent.new(position: @counter, **system_arguments)
    end
    renders_many :groups, ->(**system_arguments) do
      @counter += 1
      Polaris::FormLayout::GroupComponent.new(position: @counter, **system_arguments)
    end

    def initialize(**system_arguments)
      @counter = 0

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-FormLayout"
      )
    end

    def render?
      all_items.any?
    end

    def all_items
      @all_items ||= items + groups
    end

    def ordered_items
      all_items.sort_by(&:position)
    end
  end
end
