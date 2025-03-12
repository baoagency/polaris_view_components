class Polaris::NewTabs::TabComponent < Polaris::Component
  renders_one :badge, Polaris::BadgeComponent

  def initialize(
    title:,
    url: nil,
    active: false,
    **system_arguments
  )
    @title = title
    @url = url
    @active = active
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:rol] = "tab"
      opts[:tabindex] = "0"
      if @url.present?
        opts[:tag] = "a"
        opts[:href] = @url
      else
        opts[:tag] = "button"
        opts[:type] = "button"
      end
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Tabs__Tab",
        "Polaris-Tabs__Tab--active": @active
      )
    end
  end
end
