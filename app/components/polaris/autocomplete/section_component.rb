module Polaris
  class Autocomplete::SectionComponent < Component
    renders_many :options, ->(**system_arguments) do
      Autocomplete::OptionComponent.new(multiple: @multiple, **system_arguments)
    end

    def initialize(multiple: false, **system_arguments)
      @multiple = multiple
      @system_arguments = system_arguments
    end
  end
end
