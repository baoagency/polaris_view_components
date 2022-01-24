# frozen_string_literal: true

module Polaris
  class ChoiceComponent < Polaris::Component
    def initialize(
      label:,
      label_hidden:,
      help_text:,
      disabled:,
      error: nil,
      children_content: nil,
      **system_arguments
    )
      @label = label
      @help_text = help_text
      @error = error
      @children_content = children_content

      @system_arguments = system_arguments
      @system_arguments[:tag] = "label"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Choice",
        "Polaris-Choice--labelHidden": label_hidden,
        "Polaris-Choice--disabled": disabled
      )
    end
  end
end
