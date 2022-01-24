class Polaris::OptionList::OptionComponent < Polaris::Component
  def initialize(**system_arguments)
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "li"
      opts[:tabindex] = "-1"
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-OptionList-Option"
      )
    end
  end

  def call
    render(Polaris::BaseComponent.new(**system_arguments)) do
      tag.label(class: "Polaris-OptionList-Option__Label") do
        content
      end
    end
  end
end
