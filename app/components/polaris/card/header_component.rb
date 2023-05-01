class Polaris::Card::HeaderComponent < Polaris::Component
  def initialize(
    title: "",
    actions: [],
    **system_arguments
  )
    @system_arguments = system_arguments
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      @system_arguments[:classes],
      "Polaris-LegacyCard__Header"
    )

    @title = title
    @actions = actions.map { |a| a.merge(plain: true) }
  end

  def simple?
    content.blank? && @actions.blank?
  end
end
