# frozen_string_literal: true

module Polaris
  class BannerComponent < Polaris::Component
    STATUS_DEFAULT = :default
    STATUS_MAPPINGS = {
      STATUS_DEFAULT => "",
      :success => "Polaris-Banner--statusSuccess",
      :info => "Polaris-Banner--statusInfo",
      :warning => "Polaris-Banner--statusWarning",
      :critical => "Polaris-Banner--statusCritical"
    }
    STATUS_OPTIONS = STATUS_MAPPINGS.keys

    WITHIN_DEFAULT = :page
    WITHIN_MAPPINGS = {
      page: "Polaris-Banner--withinPage",
      container: "Polaris-Banner--withinContentContainer"
    }
    WITHIN_OPTIONS = WITHIN_MAPPINGS.keys

    ICON_COLOR_MAPPINGS = {
      default: :base,
      success: :success,
      info: :highlight,
      warning: :warning,
      critical: :critical
    }

    renders_one :action, ->(**system_arguments) do
      Polaris::ButtonComponent.new(classes: "Polaris-Banner__Button Polaris-Banner__PrimaryAction", **system_arguments)
    end
    renders_one :secondary_action, "SecondaryAction"
    renders_one :dismiss_button, ->(**system_arguments) do
      render Polaris::ButtonComponent.new(plain: true, **system_arguments) do |button|
        button.with_icon(name: "CancelSmallMinor")
      end
    end

    def initialize(
      status: STATUS_DEFAULT,
      within: WITHIN_DEFAULT,
      icon: nil,
      hide_icon: false,
      title: nil,
      **system_arguments
    )
      @status = status
      @icon = icon || default_icon(status)
      @hide_icon = hide_icon
      @title = title

      @system_arguments = system_arguments
      @system_arguments[:tabindex] = 0
      @system_arguments[:role] = "status"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Banner",
        STATUS_MAPPINGS[fetch_or_fallback(STATUS_OPTIONS, status, STATUS_DEFAULT)],
        WITHIN_MAPPINGS[fetch_or_fallback(WITHIN_OPTIONS, within, WITHIN_DEFAULT)]
      )
    end

    def render_icon
      polaris_icon(name: @icon, color: ICON_COLOR_MAPPINGS[@status])
    end

    def default_icon(status)
      case status
      when :success then "CircleTickMajor"
      when :critical then "DiamondAlertMajor"
      else
        "CircleInformationMajor"
      end
    end

    class SecondaryAction < Polaris::Component
      def initialize(**system_arguments)
        @system_arguments = system_arguments
      end

      def call
        render(BaseButton.new(classes: "Polaris-Banner__SecondaryAction", **@system_arguments)) do
          tag.span(class: "Polaris-Banner__Text") do
            content
          end
        end
      end
    end
  end
end
