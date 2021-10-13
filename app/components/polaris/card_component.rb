# frozen_string_literal: true

module Polaris
  class CardComponent < Polaris::NewComponent
    FOOTER_ACTION_ALIGNMENT_DEFAULT = :right
    FOOTER_ACTION_ALIGNMENT_MAPPINGS = {
      FOOTER_ACTION_ALIGNMENT_DEFAULT => "",
      :left => "Polaris-Card__LeftJustified",
    }
    FOOTER_ACTION_ALIGNMENT_OPTIONS = FOOTER_ACTION_ALIGNMENT_MAPPINGS.keys

    renders_one :header, Polaris::Card::HeaderComponent
    renders_many :sections, Polaris::Card::SectionComponent
    renders_one :primary_footer_action, -> (primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    renders_many :secondary_footer_actions, Polaris::ButtonComponent

    def initialize(
      title: "",
      actions: [],
      sectioned: true,
      subdued: false,
      footer_action_alignment: FOOTER_ACTION_ALIGNMENT_DEFAULT,
      **system_arguments
    )
      @title = title
      @actions = actions
      @sectioned = sectioned
      @footer_action_alignment = footer_action_alignment

      @system_arguments = system_arguments
      @system_arguments[:tag] = :div
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Card",
        "Polaris-Card--subdued": subdued,
      )
    end

    def render_footer?
      primary_footer_action.present? || secondary_footer_actions.any?
    end

    def footer_classes
      class_names(
        "Polaris-Card__Footer",
        FOOTER_ACTION_ALIGNMENT_MAPPINGS[fetch_or_fallback(FOOTER_ACTION_ALIGNMENT_OPTIONS, @footer_action_alignment, FOOTER_ACTION_ALIGNMENT_DEFAULT)],
      )
    end
  end
end
