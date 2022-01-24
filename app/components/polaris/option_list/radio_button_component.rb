class Polaris::OptionList::RadioButtonComponent < Polaris::Component
  def initialize(
    label:,
    value:,
    wrapper_arguments: {},
    **system_arguments
  )
    @label = label
    @value = value
    @wrapper_arguments = wrapper_arguments
    @system_arguments = system_arguments
  end

  def wrapper_arguments
    @wrapper_arguments.tap do |opts|
      opts[:tag] = "li"
      opts[:tabindex] = "-1"
      opts[:classes] = class_names(
        @wrapper_arguments[:classes],
        "Polaris-OptionList-Option"
      )
    end
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris--hidden"
      )
    end
  end

  def call
    render(Polaris::BaseComponent.new(**wrapper_arguments)) do
      tag.label(
        class: "Polaris-OptionList-Option__SingleSelectOption",
        data: {
          polaris_option_list_target: "radioButton",
          action: "click->polaris-option-list#update"
        }
      ) do
        safe_join [
          radio_button,
          @label
        ]
      end
    end
  end

  def radio_button
    render Polaris::BaseRadioButton.new(value: @value, **system_arguments)
  end
end
