# frozen_string_literal: true

module Polaris
  class CardComponent < Polaris::NewComponent
    include Polaris::Helpers::ActionHelper

    renders_one :header, "Polaris::CardComponent::HeaderComponent"
    renders_many :sections, "Polaris::CardComponent::SectionComponent"

    def initialize(
      title: "",
      actions: [],
      subdued: false,
      primary_footer_action: nil,
      secondary_footer_actions: [],
      footer_action_alignment: 'right',
      **system_arguments
    )
      @system_arguments = system_arguments
      @system_arguments[:tag] = :div
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Card",
        "Polaris-Card--subdued": subdued,
      )

      @title = title
      @actions = actions
      @primary_footer_action = primary_footer_action
      @secondary_footer_actions = secondary_footer_actions
      @footer_action_alignment = footer_action_alignment
    end

    def footer?
      @primary_footer_action.present? || @secondary_footer_actions.present?
    end
  end
end
