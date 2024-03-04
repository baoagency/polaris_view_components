# frozen_string_literal: true

module Polaris
  class SpinnerComponent < Polaris::Component
    include ActiveModel::Validations

    attr_reader :has_focusable_parent, :size

    SIZE_DEFAULT = :large
    SIZE_MAPPINGS = {
      small: "Polaris-Spinner--sizeSmall",
      large: "Polaris-Spinner--sizeLarge"
    }
    SIZE_OPTIONS = SIZE_MAPPINGS.keys
    validates :size, inclusion: {in: SIZE_OPTIONS}
    validates :has_focusable_parent, inclusion: {in: [true, false]}

    def initialize(
      accessibility_label: nil,
      size: SIZE_DEFAULT,
      has_focusable_parent: false,
      **system_arguments
    )
      @accessibility_label = accessibility_label
      @has_focusable_parent = has_focusable_parent
      @size = size

      @system_arguments = system_arguments
      @system_arguments[:tag] = :span
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Spinner",
        SIZE_MAPPINGS[fetch_or_fallback(SIZE_OPTIONS, size, SIZE_DEFAULT)]
      )
    end

    def span_arguments
      arguments = {
        tag: :span
      }

      arguments[:role] = :status unless @has_focusable_parent

      arguments
    end

    def render_accessibility?
      !@has_focusable_parent && @accessibility_label.present?
    end
  end
end
