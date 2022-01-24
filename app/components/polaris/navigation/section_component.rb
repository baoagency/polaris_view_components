class Polaris::Navigation::SectionComponent < Polaris::Component
  renders_many :items, Polaris::Navigation::ItemComponent
  renders_one :action, "ActionComponent"

  def initialize(
    title: nil,
    separator: false,
    fill: false,
    **system_arguments
  )
    @title = title
    @separator = separator
    @fill = fill
    @system_arguments = system_arguments
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "ul"
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Navigation__Section",
        "Polaris-Navigation__Section--fill": @fill,
        "Polaris-Navigation__Section--withSeparator": @separator
      )
    end
  end

  class ActionComponent < Polaris::Component
    def initialize(url: nil, external: false, icon: nil, **system_arguments)
      @url = url
      @external = external
      @icon = icon
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
          "Polaris-Navigation__Action"
        )
      end
    end

    def call
      render(Polaris::BaseComponent.new(**system_arguments)) do
        if @icon.present?
          render(Polaris::IconComponent.new(name: @icon))
        else
          content
        end
      end
    end
  end
end
