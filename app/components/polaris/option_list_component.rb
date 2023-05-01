module Polaris
  class OptionListComponent < Polaris::Component
    renders_many :sections, ->(**system_arguments) do
      @sections_count += 1

      Polaris::OptionList::SectionComponent.new(
        position: @sections_count - 1,
        form: @form,
        attribute: @attribute,
        name: @name,
        selected: @selected,
        **system_arguments
      )
    end
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
      title: nil,
      form: nil,
      attribute: nil,
      name: nil,
      selected: [],
      **system_arguments
    )
      @sections_count = 0

      @title = title
      @form = form
      @attribute = attribute
      @name = name
      @selected = selected
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |args|
        args[:data] ||= {}
        prepend_option(args[:data], :controller, "polaris-option-list")
        args[:data][:polaris_option_list_selected_class] = "Polaris-OptionList-Option--select"
      end
    end

    def items
      radio_buttons.presence || checkboxes.presence || options
    end
  end
end
