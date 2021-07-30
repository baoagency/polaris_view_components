# frozen_string_literal: true

module Polaris
  class IconComponent < Polaris::NewComponent
    COLOR_DEFAULT = :default
    COLOR_MAPPINGS = {
      COLOR_DEFAULT => "",
      :base => "Polaris-Icon--colorBase",
      :subdued => "Polaris-Icon--colorSubdued",
      :critical => "Polaris-Icon--colorCritical",
      :warning => "Polaris-Icon--colorWarning",
      :highlight => "Polaris-Icon--colorHighlight",
      :success => "Polaris-Icon--colorSuccess",
      :primary => "Polaris-Icon--colorPrimary",
    }
    COLOR_OPTIONS = COLOR_MAPPINGS.keys

    def initialize(
      name: nil,
      backdrop: false,
      color: COLOR_DEFAULT,
      **system_arguments
    )
      @source = name ? polaris_icon_source(name) : nil

      @system_arguments = system_arguments
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Icon",
        COLOR_MAPPINGS[fetch_or_fallback(COLOR_OPTIONS, color, COLOR_DEFAULT)],
        "Polaris-Icon--hasBackdrop" => backdrop,
        "Polaris-Icon--applyColor" => color != :default,
      )
    end
  end
end
