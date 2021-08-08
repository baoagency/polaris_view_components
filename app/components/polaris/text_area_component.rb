# frozen_string_literal: true

module Polaris
  class TextAreaComponent < Polaris::NewComponent
    def initialize(rows: 2, **system_arguments)
      @system_arguments = system_arguments.deep_merge({
        input: :text_area,
        classes: class_names(
          system_arguments[:classes],
          "Polaris-TextField--multiline",
        ),
        input_options: {
          rows: rows,
        }
      })
    end

    def call
      render(Polaris::TextFieldComponent.new(**@system_arguments)) { content }
    end
  end
end
