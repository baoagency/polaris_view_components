# frozen_string_literal: true

module Polaris
  class FiltersComponent < Polaris::Component
    renders_one :query, ->(**system_arguments) do
      QueryComponent.new(disabled: @disabled, **system_arguments)
    end
    renders_many :items, ->(**system_arguments) do
      ItemComponent.new(disabled: @disabled, **system_arguments)
    end
    renders_one :tags

    def initialize(disabled: false, help_text: nil, **system_arguments)
      @disabled = disabled
      @help_text = help_text
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-LegacyFilters"
        )
      end
    end

    def items_wrapper_classes
      class_names(
        "Polaris-LegacyFilters-ConnectedFilterControl__RightContainer",
        "Polaris-LegacyFilters-ConnectedFilterControl__RightContainerWithoutMoreFilters",
        "Polaris-LegacyFilters-ConnectedFilterControl--queryFieldHidden": @query.blank?
      )
    end

    class QueryComponent < Polaris::Component
      def initialize(clear_button: true, disabled: false, **system_arguments)
        @disabled = disabled
        @system_arguments = system_arguments.merge(
          label_hidden: true,
          clear_button: clear_button
        )
      end

      def call
        polaris_text_field(disabled: @disabled, **@system_arguments) do |text_field|
          text_field.with_prefix do
            polaris_icon(name: "SearchIcon")
          end
        end
      end
    end

    class ItemComponent < Polaris::Component
      def initialize(label:, sectioned: true, width: nil, disabled: false, **system_arguments)
        @label = label
        @sectioned = sectioned
        @width = width
        @disabled = disabled
        @system_arguments = system_arguments
      end

      def system_arguments
        @system_arguments.tap do |opts|
          opts[:tag] = "div"
          opts[:classes] = class_names(
            @system_arguments[:classes],
            "Polaris-LegacyFilters-ConnectedFilterControl__Item"
          )
        end
      end

      def popover_arguments
        {
          sectioned: @sectioned,
          style: ("width: #{@width}" if @width.present?),
          position: :below,
          alignment: :left
        }
      end

      def call
        render(Polaris::BaseComponent.new(**system_arguments)) do
          render(Polaris::PopoverComponent.new(**popover_arguments)) do |popover|
            popover.with_button(disclosure: true, disabled: @disabled) { @label }
            content
          end
        end
      end
    end
  end
end
