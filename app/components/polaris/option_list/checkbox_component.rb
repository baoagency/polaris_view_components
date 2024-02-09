class Polaris::OptionList::CheckboxComponent < Polaris::Component
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
        "Polaris-Checkbox__Input"
      )
    end
  end

  def checkbox
    render Polaris::BaseCheckbox.new(value: @value, **system_arguments)
  end
end
