class Polaris::Modal::SectionComponent < Polaris::Component
  def initialize(**system_arguments)
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "div"
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Modal-Section"
      )
    end
  end

  def call
    render(Polaris::BaseComponent.new(**system_arguments)) { content }
  end
end
