class Polaris::ActionList::ItemComponent < Polaris::Component
  renders_one :prefix
  renders_one :suffix

  def initialize(
    url: nil,
    icon: nil,
    icon_name: nil,
    help_text: nil,
    active: false,
    destructive: false,
    external: false,
    **system_arguments
  )
    @url = url
    @icon = icon || icon_name
    @help_text = help_text
    @active = active
    @destructive = destructive
    @external = external
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      if @url.present?
        opts[:tag] = "a"
        opts[:href] = @url
        opts[:target] = "_blank" if @external
      else
        opts[:tag] = "button"
        opts[:type] = "button"
      end
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-ActionList__Item",
        "Polaris-ActionList--active": @active,
        "Polaris-ActionList--destructive": @destructive
      )
    end
  end
end
