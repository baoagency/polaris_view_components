# frozen_string_literal: true

module Polaris
  class DataTableComponent < Polaris::NewComponent
    ALIGNMENT_DEFAULT = :top
    ALIGNMENT_OPTIONS = [:top, :bottom, :middle, :baseline]

    renders_many :columns, -> (title, **system_arguments, &block) do
      DataTable::ColumnComponent.new(title, **system_arguments, &block)
    end
    renders_one :footer

    def initialize(
      data,
      hoverable: true,
      vertical_alignment: ALIGNMENT_DEFAULT,
      totals_in_header: false,
      totals_in_footer: false,
      **system_arguments
    )
      @data = data
      @hoverable = hoverable
      @vertical_alignment = fetch_or_fallback(ALIGNMENT_OPTIONS, vertical_alignment, ALIGNMENT_DEFAULT)
      @totals_in_header = totals_in_header
      @totals_in_footer = totals_in_footer
      @system_arguments = system_arguments
    end

    def system_arguments
      { tag: "div" }.deep_merge(@system_arguments).tap do |args|
        args[:classes] = class_names(
          args[:classes],
          "Polaris-DataTable",
        )
      end
    end

    def render_cell(**arguments, &block)
      render(DataTable::CellComponent.new(vertical_alignment: @vertical_alignment, **arguments), &block)
    end
  end
end
