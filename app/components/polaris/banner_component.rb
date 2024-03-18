# frozen_string_literal: true

module Polaris
  class BannerComponent < Polaris::Component
    STATUS_DEFAULT = :default
    STATUS_MAPPINGS = {
      STATUS_DEFAULT => "Polaris-Banner--statusInfo",
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
      Polaris::ButtonComponent.new(**system_arguments)
    end
    renders_one :secondary_action, ->(**system_arguments) do
      Polaris::ButtonComponent.new(**system_arguments)
    end
    renders_one :dismiss_button, ->(**system_arguments) do
      render Polaris::ButtonComponent.new(plain: true, **system_arguments) do |button|
        button.with_icon(name: "XSmallIcon")
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
      @within = within
      @icon = icon || default_icon(status)
      @hide_icon = hide_icon
      @title = title
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:tabindex] = 0
        opts[:role] = "status"
        opts[:tag] = "div"
        opts[:classes] = class_names(
          opts[:classes],
          "Polaris-Banner",
          STATUS_MAPPINGS[fetch_or_fallback(STATUS_OPTIONS, @status, STATUS_DEFAULT)],
          WITHIN_MAPPINGS[fetch_or_fallback(WITHIN_OPTIONS, @within, WITHIN_DEFAULT)],
          "Polaris-Banner--onlyTitle": has_title? && !has_content?
        )
      end
    end

    def render_icon
      polaris_icon(name: @icon, color: ICON_COLOR_MAPPINGS[@status])
    end

    def default_icon(status)
      case status
      when :success then "CheckIcon"
      when :critical then "AlertDiamondIcon"
      when :warning then "AlertTriangleIcon"
      else
        "InfoIcon"
      end
    end

    def within_container?
      @within == :container
    end

    def has_title?
      @title.present?
    end

    def has_content?
      content.present? || action || secondary_action
    end
  end
end
