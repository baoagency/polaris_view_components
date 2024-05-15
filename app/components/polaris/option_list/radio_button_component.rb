class Polaris::OptionList::RadioButtonComponent < Polaris::Component
  renders_one :prefix
  renders_one :suffix

  def initialize(
    label:,
    value:,
    prefix: nil,
    suffix: nil,
    wrapper_arguments: {},
    **system_arguments
  )
    @label = label
    @value = value
    @prefix = prefix
    @suffix = suffix
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

  def radio_button
    render Polaris::BaseRadioButton.new(value: @value, **system_arguments)
  end
end
