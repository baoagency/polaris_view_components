class Polaris::IndexTable::CellComponent < Polaris::Component
  def initialize(flush: false, **system_arguments)
    @flush = flush
    @system_arguments = system_arguments
  end

  def system_arguments
    {tag: "td"}.deep_merge(@system_arguments).tap do |args|
      args[:classes] = class_names(
        args[:classes],
        "Polaris-IndexTable__TableCell",
        "Polaris-IndexTable__TableCell--flush": @flush
      )
    end
  end

  def call
    render(Polaris::BaseComponent.new(**system_arguments)) do
      content
    end
  end
end
