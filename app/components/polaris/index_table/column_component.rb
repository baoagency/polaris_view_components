class Polaris::IndexTable::ColumnComponent < Polaris::Component
  attr_reader :title, :flush, :system_arguments

  def initialize(title, flush: false, **system_arguments, &block)
    @title = title
    @flush = flush
    @block = block
    @system_arguments = system_arguments
  end

  def call(row)
    @block.call(row)
  end
end
