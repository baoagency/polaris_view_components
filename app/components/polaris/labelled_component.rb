# frozen_string_literal: true

module Polaris
  class LabelledComponent < Polaris::Component
    renders_one :label_action, ->(**system_arguments) do
      Polaris::ButtonComponent.new(plain: true, **system_arguments)
    end

    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      label: nil,
      label_hidden: false,
      label_action: nil,
      required: false,
      help_text: nil,
      error: nil,
      **system_arguments
    )
      @help_text = help_text
      @error = error

      if label_action && label_action[:content].present?
        label_content = label_action.delete(:content)
        with_label_action(**label_action) { label_content }
      end

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
        required: required
      }
    end

    def renders_error?
      @error.present? && @error.is_a?(String)
    end
  end
end
