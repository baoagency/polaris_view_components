class Polaris::ExceptionList::ItemComponent < Polaris::Component
  STATUS_DEFAULT = :default
  STATUS_MAPPINGS = {
    STATUS_DEFAULT => "",
    :critical => "Polaris-ExceptionList--statusCritical",
    :warning => "Polaris-ExceptionList--statusWarning"
  }
  STATUS_OPTIONS = STATUS_MAPPINGS.keys

  def initialize(
    icon: nil,
    title: nil,
    status: STATUS_DEFAULT,
    **system_arguments
  )
    @icon = icon
    @title = title

    @system_arguments = system_arguments
    @system_arguments[:tag] = "li"
    @system_arguments[:classes] = class_names(
      @system_arguments[:classes],
      "Polaris-ExceptionList__Item",
      STATUS_MAPPINGS[fetch_or_fallback(STATUS_OPTIONS, status, STATUS_DEFAULT)]
    )
  end
end
