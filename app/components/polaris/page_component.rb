# frozen_string_literal: true

module Polaris
  class PageComponent < Polaris::NewComponent
    renders_one :primary_action, ->(primary: true, **system_arguments) do
      Polaris::ButtonComponent.new(primary: primary, **system_arguments)
    end
    # renders_many :secondary_actions, Polaris::ButtonComponent
    renders_one :title_metadata
    renders_one :thumbnail, Polaris::ThumbnailComponent

    def initialize(
      title: nil,
      subtitle: nil,
      back_url: nil,
      narrow_width: false,
      full_width: false,
      divider: false,
      **system_arguments
    )
      @title = title
      @subtitle = subtitle
      @back_url = back_url

      @system_arguments = system_arguments
      @system_arguments[:tag] = "div"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Page",
        "Polaris-Page--narrowWidth": narrow_width,
        "Polaris-Page--fullWidth": full_width
      )

      @header_arguments = {}
      @header_arguments[:tag] = "div"
      @header_arguments[:classes] = class_names(
        "Polaris-Page-Header",
        "Polaris-Page-Header--mobileView",
        "Polaris-Page-Header--mediumTitle",
        "Polaris-Page-Header--hasNavigation": back_url.present?,
        "Polaris-Page-Header--noBreadcrumbs": back_url.blank?
      )

      @content_arguments = {}
      @content_arguments[:tag] = "div"
      @content_arguments[:classes] = class_names(
        "Polaris-Page__Content",
        "Polaris-Page--divider": divider
      )
    end

    def render_header?
      @title.present? || @subtitle.present? || @back_url.present? || primary_action.present?
    end
  end
end
