module Polaris
  class Autocomplete::OptionComponent < Component
    renders_one :prefix
    renders_one :suffix

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
        args[:wrapper_arguments][:data][:polaris_autocomplete_target] = "option"
        args[:wrapper_arguments][:data][:label] = @label

        args[:data] ||= {}
        prepend_option(args[:data], :action, "polaris-autocomplete#select")
      end
    end
  end
end
