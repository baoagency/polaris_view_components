# frozen_string_literal: true

module Polaris
  class SkeletonPageComponent < Polaris::Component
    def initialize(
      title: nil,
      primary_action: false,
      narrow_width: false,
      full_width: false,
      back_action: false,
      **system_arguments
    )
      @title = title
      @primary_action = primary_action
      @narrow_width = narrow_width
      @full_width = full_width
      @back_action = back_action
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:role] = "status"
      end
    end

    def page_width
      if @narrow_width
        "var(--pc-skeleton-page-max-width-narrow)"
      elsif @full_width
        "none"
      else
        "var(--pc-skeleton-page-max-width)"
      end
    end
  end
end
