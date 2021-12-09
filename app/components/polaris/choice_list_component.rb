# frozen_string_literal: true

module Polaris
  class ChoiceListComponent < Polaris::NewComponent
    renders_many :checkboxes, ->(value:, disabled: false, **system_arguments) do
      Polaris::CheckboxComponent.new(
        form: @form,
        attribute: @attribute,
        name: @name && "#{@name}[]",
        value: value,
        checked: @selected.include?(value),
        disabled: disabled || @disabled,
        **system_arguments
      )
    end
    renders_many :radio_buttons, ->(value:, disabled: false, **system_arguments) do
      Polaris::RadioButtonComponent.new(
        form: @form,
        attribute: @attribute,
        name: @name,
        value: value,
        checked: @selected.include?(value),
        disabled: disabled || @disabled,
        **system_arguments
      )
    end

    def initialize(
      title: nil,
      title_hidden: false,
      form: nil,
      attribute: nil,
      name: nil,
      selected: [],
      disabled: false,
      error: nil,
      **system_arguments
    )
      @title = title
      @error = error
      @form = form
      @attribute = attribute
      @name = name
      @selected = selected
      @disabled = disabled

      @system_arguments = system_arguments
      @system_arguments[:tag] = "fieldset"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ChoiceList",
        "Polaris-ChoiceList--titleHidden": title_hidden
      )
    end

    def items
      checkboxes.presence || radio_buttons
    end

    def renders?
      items.any?
    end

    def multiple_choice_allowed?
      checkboxes.any?
    end
  end
end
