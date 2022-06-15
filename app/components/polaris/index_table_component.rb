module Polaris
  class IndexTableComponent < Polaris::Component
    renders_many :columns, ->(title, **system_arguments, &block) do
      IndexTable::ColumnComponent.new(title, **system_arguments, &block)
    end

    def initialize(data, **system_arguments)
      @data = data
      @system_arguments = system_arguments
    end

    def system_arguments
      {tag: "div"}.deep_merge(@system_arguments).tap do |args|
        args[:classes] = class_names(
          args[:classes],
          "Polaris-IndexTable"
        )
      end
    end

    def row_arguments(row)
      {tag: "tr"}.tap do |args|
        args[:classes] = class_names(
          "Polaris-IndexTable__TableRow",
          "Polaris-IndexTable__TableRow--unclickable"
        )
        args[:id] = dom_id(row) if row.respond_to?(:to_key)
      end
    end

    def render_cell(**arguments, &block)
      render(IndexTable::CellComponent.new(**arguments), &block)
    end
  end
end
