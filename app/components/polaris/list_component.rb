# frozen_string_literal: true

module Polaris
  class ListComponent < Polaris::NewComponent
    renders_many :items, "ListItemComponent"

    TYPE_DEFAULT = :bullet
    TYPE_TAG_MAPPINGS = {
      bullet: :ul,
      number: :ol,
    }
    TYPE_CLASS_MAPPINGS = {
      bullet: "",
      number: "Polaris-List--typeNumber",
    }
    TYPE_OPTIONS = TYPE_TAG_MAPPINGS.keys

    def initialize(
      type: TYPE_DEFAULT,
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = TYPE_TAG_MAPPINGS[fetch_or_fallback(TYPE_OPTIONS, type, :ul)]
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-List",
        TYPE_CLASS_MAPPINGS[fetch_or_fallback(TYPE_OPTIONS, type, "")],
      )
    end

    class ListItemComponent < Polaris::NewComponent
      def initialize(**system_arguments)
        @system_arguments = system_arguments
        @system_arguments[:tag] = :li
        @system_arguments[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-List__Item"
        )
      end

      def call
        render(Polaris::BaseComponent.new(**@system_arguments)) { content }
      end
    end
  end
end
