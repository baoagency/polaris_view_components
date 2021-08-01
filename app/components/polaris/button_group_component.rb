# frozen_string_literal: true

module Polaris
  class ButtonGroupComponent < Polaris::NewComponent
    SPACING_DEFAULT = :default
    SPACING_MAPPINGS = {
      SPACING_DEFAULT => "",
      :extra_tight => "Polaris-ButtonGroup--extraTight",
      :tight => "Polaris-ButtonGroup--tight",
      :loose => "Polaris-ButtonGroup--loose",
    }
    SPACING_OPTIONS = SPACING_MAPPINGS.keys

    renders_many :buttons, -> (**system_arguments) do
      @counter += 1

      ButtonGroupItemButtonComponent.new(position: @counter, **system_arguments)
    end

    renders_many :items, -> (**system_arguments) do
      @counter += 1

      ButtonGroupItemComponent.new(position: @counter, **system_arguments)
    end

    def initialize(
      connected_top: false,
      full_width: false,
      segmented: false,
      spacing: SPACING_DEFAULT,
      **system_arguments
    )
      @counter = 0

      @system_arguments = system_arguments
      if connected_top
        @system_arguments["data-buttongroup-connected-top"] = true
      end
      if full_width
        @system_arguments["data-buttongroup-full-width"] = true
      end
      if segmented
        @system_arguments["data-buttongroup-segmented"] = true
      end
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ButtonGroup",
        SPACING_MAPPINGS[fetch_or_fallback(SPACING_OPTIONS, spacing, SPACING_DEFAULT)],
        "Polaris-ButtonGroup--fullWidth": full_width,
        "Polaris-ButtonGroup--segmented": segmented,
      )
    end

    def render?
      buttons.any? || items.any?
    end

    def all_items
      @all_items ||= buttons + items
    end

    def ordered_items
      all_items.sort_by(&:position)
    end

    class ButtonGroupItemButtonComponent < Polaris::NewComponent
      attr_reader :position

      def initialize(position:, **system_arguments)
        @position = position

        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-ButtonGroup__Item",
          "Polaris-ButtonGroup__Item--plain": system_arguments.key?(:plain)
        )
      end

      def call
        button_arguments = @system_arguments.except(:classes, :tag)

        render(Polaris::BaseComponent.new(**@system_arguments.except(:plain))) do
          render(Polaris::ButtonComponent.new(**button_arguments)) { content }
        end
      end
    end

    class ButtonGroupItemComponent < Polaris::NewComponent
      attr_reader :position

      def initialize(position:, **system_arguments)
        @position = position

        @system_arguments = system_arguments
        @system_arguments[:tag] = :div
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-ButtonGroup__Item",
        )
      end

      def call
        render(Polaris::BaseComponent.new(**@system_arguments)) { content }
      end
    end
  end
end
