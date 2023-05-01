class Polaris::OptionList::SectionComponent < Polaris::Component
  renders_many :options, Polaris::OptionList::OptionComponent
  renders_many :radio_buttons, ->(value:, **system_arguments) do
    Polaris::OptionList::RadioButtonComponent.new(
      form: @form,
      attribute: @attribute,
      name: @name,
      value: value,
      checked: @selected.include?(value),
      **system_arguments
    )
  end
  renders_many :checkboxes, ->(value:, **system_arguments) do
    Polaris::OptionList::CheckboxComponent.new(
      form: @form,
      attribute: @attribute,
      name: @name && "#{@name}[]",
      value: value,
      checked: @selected.include?(value),
      **system_arguments
    )
  end

  def initialize(
    position: 0,
    title: nil,
    form: nil,
    attribute: nil,
    name: nil,
    selected: [],
    **system_arguments
  )
    @position = position
    @title = title
    @form = form
    @attribute = attribute
    @name = name
    @selected = selected
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "ul"
    end
  end

  def items
    radio_buttons.presence || checkboxes.presence || options
  end
end
