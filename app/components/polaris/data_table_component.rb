# frozen_string_literal: true

module Polaris
  class DataTableComponent < Polaris::Component
    ALIGNMENT_DEFAULT = :top
    ALIGNMENT_OPTIONS = [:top, :bottom, :middle, :baseline]

    renders_many :columns, ->(title, **system_arguments, &block) do
      DataTable::ColumnComponent.new(title, **system_arguments, &block)
    end
    renders_one :footer

    def initialize(
      data,
      hoverable: true,
      vertical_alignment: ALIGNMENT_DEFAULT,
      totals_in_header: false,
      totals_in_footer: false,
      increased_density: false,
      **system_arguments
    )
      @data = data
      @hoverable = hoverable
      @vertical_alignment = fetch_or_fallback(ALIGNMENT_OPTIONS, vertical_alignment, ALIGNMENT_DEFAULT)
      @totals_in_header = totals_in_header
      @totals_in_footer = totals_in_footer
      @increased_density = increased_density
      @system_arguments = system_arguments
    end

    def system_arguments
      {tag: "div"}.deep_merge(@system_arguments).tap do |args|
        args[:classes] = class_names(
          args[:classes],
          "Polaris-DataTable"
        )
        args[:data] ||= {}
        args[:data][:controller] = "polaris-data-table"
      end
    end

    def wrapper_arguments
      {
        tag: "div",
        classes: class_names(
          "Polaris-DataTable__IncreasedTableDensity": @increased_density
        )
      }
    end

    def row_arguments(row)
      {tag: "tr"}.tap do |args|
        args[:classes] = class_names(
          "Polaris-DataTable__TableRow",
          "Polaris-DataTable--hoverable": @hoverable
        )
        args[:id] = dom_id(row) if row.respond_to?(:to_key)
        args[:data] ||= {}
        args[:data][:polaris_data_table_target] = "row"
      end
    end

    def render_cell(**arguments, &block)
      render(DataTable::CellComponent.new(vertical_alignment: @vertical_alignment, **arguments), &block)
    end
  end
end
