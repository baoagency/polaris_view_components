# frozen_string_literal: true

module Polaris
  class LabelComponent < Polaris::NewComponent
    def initialize(
      form: nil,
      attribute: nil,
      name: nil,
      label: nil,
      **system_arguments
    )
      @form = form
      @attribute = attribute
      @name = name
      @label = label

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Label",
      )

      @label_options = { class: "Polaris-Label__Text" }
    end

    def renders?
      (@form.present? && @attribute.present?) || @name.present?
    end
  end
end