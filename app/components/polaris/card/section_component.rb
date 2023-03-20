class Polaris::Card::SectionComponent < Polaris::Component
  renders_many :subsections, "Polaris::Card::SubsectionComponent"

  def initialize(
    title: "",
    subdued: false,
    flush: false,
    full_width: false,
    unstyled: false,
    border_top: false,
    border_bottom: false,
    actions: [],
    **system_arguments
  )
    @system_arguments = system_arguments
    @system_arguments[:tag] = :div
    @system_arguments[:classes] = class_names(
      @system_arguments[:classes],
      "Polaris-LegacyCard__Section": !unstyled,
      "Polaris-LegacyCard__Section--flush": flush,
      "Polaris-LegacyCard__Section--subdued": subdued,
      "Polaris-LegacyCard__Section--fullWidth": full_width,
      "Polaris-LegacyCard__Section--borderTop": border_top,
      "Polaris-LegacyCard__Section--borderBottom": border_bottom
    )

    @title = title
    @actions = actions.map { |a| a.merge(plain: true) }
  end

  class Polaris::Card::SubsectionComponent < Polaris::Component
    def initialize(**system_arguments)
      @system_arguments = system_arguments
      @system_arguments[:tag] = :div
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-LegacyCard__Subsection"
      )
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) { content }
    end
  end
end
