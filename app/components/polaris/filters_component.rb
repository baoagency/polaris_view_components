# frozen_string_literal: true

module Polaris
  class FiltersComponent < Polaris::NewComponent
    renders_one :query, "QueryComponent"

    def initialize(**system_arguments)
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = "div"
        opts[:classes] = class_names(
          @system_arguments[:classes],
          "Polaris-Filters"
        )
      end
    end

    class QueryComponent < Polaris::NewComponent
      def initialize(clear_button: true, **system_arguments)
        @system_arguments = system_arguments.merge(
          label_hidden: true,
          clear_button: clear_button
        )
      end

      def call
        polaris_text_field(**@system_arguments) do |text_field|
          text_field.prefix do
            polaris_icon(name: "SearchMinor")
          end
        end
      end
    end
  end
end
