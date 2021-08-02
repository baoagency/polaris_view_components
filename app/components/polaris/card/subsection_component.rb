class Polaris::Card::SubsectionComponent < Polaris::NewComponent
  def initialize(**system_arguments)
    @system_arguments = system_arguments
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      @system_arguments[:classes],
      "Polaris-Card__Subsection",
    )
  end
end
