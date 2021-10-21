class Polaris::IndexTable::ColumnComponent < Polaris::NewComponent
  attr_reader :title, :flush

  def initialize(title, flush: false, **system_arguments, &block)
    @title = title
    @flush = flush
    @block = block
  end

  def call(row)
    @block.call(row)
  end
end
