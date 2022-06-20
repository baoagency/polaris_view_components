module Polaris
  class Autocomplete::OptionComponent < Component
    def initialize(
      label:,
      multiple: false,
      **system_arguments
    )
      @label = label
      @multiple = multiple
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |args|
        args[:label] = @label

        args[:wrapper_arguments] ||= {}
        args[:wrapper_arguments][:data] ||= {}
        args[:wrapper_arguments][:data][:target] = "option"
        args[:wrapper_arguments][:data][:label] = @label

        args[:data] ||= {}
        prepend_option(args[:data], :action, "polaris-autocomplete-option-list#select")
      end
    end

    def call
      if @multiple
        render OptionList::CheckboxComponent.new(**system_arguments)
      else
        render OptionList::RadioButtonComponent.new(**system_arguments)
      end
    end
  end
end
