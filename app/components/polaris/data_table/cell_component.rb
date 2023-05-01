class Polaris::DataTable::CellComponent < Polaris::Component
  ALIGNMENT_DEFAULT = :top
  ALIGNMENT_MAPPINGS = {
    top: "Polaris-DataTable__Cell--verticalAlignTop",
    bottom: "Polaris-DataTable__Cell--verticalAlignBottom",
    middle: "Polaris-DataTable__Cell--verticalAlignMiddle",
    baseline: "Polaris-DataTable__Cell--verticalAlignBaseline"
  }
  ALIGNMENT_OPTIONS = ALIGNMENT_MAPPINGS.keys

  def initialize(
    vertical_alignment:,
    first: false,
    numeric: false,
    header: false,
    total: false,
    total_footer: false,
    sorted: false,
    sort_url: nil,
    hoverable: true,
    **system_arguments
  )
    @vertical_alignment = vertical_alignment
    @numeric = numeric
    @first = first
    @header = header
    @total = total
    @total_footer = total_footer
    @sorted = sorted
    @sort_url = sort_url
    @hoverable = hoverable
    @system_arguments = system_arguments
  end

  def system_arguments
    {tag: "td"}.deep_merge(@system_arguments).tap do |args|
      args[:classes] = class_names(
        args[:classes],
        "Polaris-DataTable__Cell",
        ALIGNMENT_MAPPINGS[@vertical_alignment],
        "Polaris-DataTable__Cell--firstColumn": @first,
        "Polaris-DataTable__Cell--numeric": @numeric,
        "Polaris-DataTable__Cell--header": @header,
        "Polaris-DataTable__Cell--total": @total,
        "Polaris-DataTable__Cell--sortable": @sort_url.present?,
        "Polaris-DataTable__Cell--sorted": @sorted,
        "Polaris-DataTable--cellTotalFooter": @total_footer
      )
    end
  end
end
