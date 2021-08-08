# frozen_string_literal: true

module Polaris
  class TextAreaComponent < Polaris::NewComponent
    def initialize(rows: 2, **options)
      @options = options.deep_merge({
        input: :text_area,
        classes: class_names(
          options[:classes],
          "Polaris-TextField--multiline",
        ),
        input_options: {
          rows: rows,
        }
      })
    end

    def call
      render(Polaris::TextFieldComponent.new(**@options)) { content }
    end
  end
end
