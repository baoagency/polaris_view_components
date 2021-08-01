# frozen_string_literal: true

module Polaris
  class PaginationComponent < Polaris::NewComponent
    def initialize(
      previous_url: nil,
      next_url: nil,
      label: nil,
      **system_arguments
    )
      @previous_url = previous_url
      @next_url = next_url
      @label = label

      @system_arguments = system_arguments
      @system_arguments["aria-label"] = "Pagination"

      @button_group_arguments = {}
      if label.present?
        @button_group_arguments[:segmented] = false
      else
        @button_group_arguments[:segmented] = true
      end
    end
  end
end
