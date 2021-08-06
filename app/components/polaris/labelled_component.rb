# frozen_string_literal: true

module Polaris
  class LabelledComponent < Polaris::NewComponent
    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      label: nil,
      label_hidden: false,
      help_text: nil,
      error: nil,
      **system_arguments
    )
      @help_text = help_text
      @error = error

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Labelled--hidden": label_hidden
      )

      @label_arguments = {
        form: form,
        attribute: attribute,
        name: name,
        label: label,
      }
    end

    def renders_error?
      @error.present? && @error.is_a?(String)
    end
  end
end
