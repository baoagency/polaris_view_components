# frozen_string_literal: true

module Polaris
  class ResourceListComponent < Polaris::Component
    renders_one :filters, Polaris::FiltersComponent

    def initialize(
      items: [],
      resource_name: nil,
      total_items_count: nil,
      wrapper_arguments: {},
      **system_arguments
    )
      @items = items
      @resource_name = resource_name
      @total_items_count = total_items_count

      @wrapper_arguments = wrapper_arguments
      @wrapper_arguments[:tag] = "div"
      @wrapper_arguments[:classes] = class_names(
        @wrapper_arguments[:classes],
        "Polaris-ResourceList__ResourceListWrapper"
      )

      @system_arguments = system_arguments
      @system_arguments[:tag] = "ul"
      @system_arguments[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ResourceList"
      )
    end

    def header_title
      count unless @total_items_count.nil?
    end

    def resource_string
      return @resource_name[:singular] if @items.size === 1 && !@total_items_count

      @resource_name[:plural]
    end

    def count
      "Showing #{@items.size} of #{@total_items_count} #{resource_string}"
    end
  end
end
