# frozen_string_literal: true

module Polaris
  class LinkComponent < Polaris::NewComponent
    def initialize(
      url:,
      external: false,
      monochrome: false,
      **system_arguments
    )
      @url = url
      @external = external

      @system_arguments = system_arguments
      @system_arguments[:href] = @url
      @system_arguments[:"data-polaris-unstyled"] = true
      if external
        @system_arguments[:rel] = "noopener noreferrer"
        @system_arguments[:target] = "_blank"
      end
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Link",
        "Polaris-Link--monochrome" => monochrome,
      )
    end

    private

    def external_icon
      tag.span(class: "Polaris-Link__IconLockup") do
        tag.span(class: "Polaris-Link__IconLayout") do
          polaris_icon(name: "ExternalSmallMinor", aria: { label: "(opens a new window)" })
        end
      end
    end
  end
end
