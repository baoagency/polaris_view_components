# frozen_string_literal: true

module Polaris
  class CardComponent < Polaris::Component
    FOOTER_ACTION_ALIGNMENT_DEFAULT = :right
    FOOTER_ACTION_ALIGNMENT_MAPPINGS = {
      FOOTER_ACTION_ALIGNMENT_DEFAULT => "",
      :left => "Polaris-LegacyCard__LeftJustified"
    }
    FOOTER_ACTION_ALIGNMENT_OPTIONS = FOOTER_ACTION_ALIGNMENT_MAPPINGS.keys

    renders_one :tabs, Polaris::TabsComponent
    renders_one :header, Polaris::Card::HeaderComponent
    renders_many :sections, Polaris::Card::SectionComponent
    renders_one :primary_footer_action, ->(primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    renders_many :secondary_footer_actions, Polaris::ButtonComponent

    def initialize(
      title: "",
      actions: [],
      sectioned: true,
      subdued: false,
      borders: true,
      footer_action_alignment: FOOTER_ACTION_ALIGNMENT_DEFAULT,
      **system_arguments
    )
      @title = title
      @actions = actions
      @sectioned = sectioned
      @subdued = subdued
      @borders = borders
      @footer_action_alignment = footer_action_alignment
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tag] = :div
        opts[:classes] = class_names(
          opts[:classes],
          "Polaris-LegacyCard",
          "Polaris-LegacyCard--subdued": @subdued,
          "Polaris-LegacyCard--withoutTitle": @title.blank?,
          "Polaris-LegacyCard--borderless": !@borders
        )
      end
    end

    def render_footer?
      primary_footer_action.present? || secondary_footer_actions.any?
    end

    def footer_classes
      class_names(
        "Polaris-LegacyCard__Footer",
        FOOTER_ACTION_ALIGNMENT_MAPPINGS[fetch_or_fallback(FOOTER_ACTION_ALIGNMENT_OPTIONS, @footer_action_alignment, FOOTER_ACTION_ALIGNMENT_DEFAULT)]
      )
    end
  end
end
