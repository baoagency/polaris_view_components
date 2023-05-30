# frozen_string_literal: true

module Polaris
  class LinkComponent < Polaris::Component
    def initialize(
      url:,
      external: false,
      monochrome: false,
      no_underline: false,
      **system_arguments
    )
      @url = url
      @external = external

      @system_arguments = system_arguments
      @system_arguments[:href] = @url
      @system_arguments[:tag] = "a"
      @system_arguments[:"data-polaris-unstyled"] = true
      if external
        @system_arguments[:rel] = "noopener noreferrer"
        @system_arguments[:target] = "_blank"
      end
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Link",
        "Polaris-Link--monochrome" => monochrome,
        "Polaris-Link--removeUnderline" => no_underline
      )
    end

    def call
      render(Polaris::BaseComponent.new(**@system_arguments)) do
        content&.strip&.html_safe
      end
    end
  end
end
