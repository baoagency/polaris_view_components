class Polaris::Navigation::ItemComponent < Polaris::Component
  renders_many :sub_items, Polaris::Navigation::ItemComponent
  renders_many :secondary_actions, "SecondaryActionComponent"

  attr_reader :selected

  def initialize(
    url:,
    label:,
    icon: nil,
    badge: nil,
    selected: false,
    disabled: false,
    external: false,
    action_type: :link,
    link_arguments: {},
    **system_arguments
  )
    @url = url
    @label = label
    @icon = icon
    @badge = badge
    @selected = selected
    @disabled = disabled
    @external = external
    @system_arguments = system_arguments
    @action_type = action_type
    @link_arguments = link_arguments
    @item_inner_wrapper_classes = item_inner_wrapper_classes
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:tag] = "li"
      opts[:classes] = class_names(
        @system_arguments[:classes],
        "Polaris-Navigation__ListItem"
      )
    end
  end

  def link_arguments
    @link_arguments.tap do |opts|
      opts[:class] = class_names(
        @link_arguments[:classes],
        link_classes
      )
      opts[:tabindex] = "0"
      opts[:target] = "_blank" if @external
    end
  end

  def item_inner_wrapper_classes
    class_names(
      "Polaris-Navigation__ItemInnerWrapper",
      "Polaris-Navigation__ItemInnerWrapper--selected": @selected,
      "Polaris-Navigation__ItemInnerDisabled": @disabled
    )
  end

  def link_classes
    class_names(
      "Polaris-Navigation__Item",
      "Polaris-Navigation__Item--selected": @selected,
      "Polaris-Navigation--subNavigationActive": @selected || selected_sub_items?,
      "Polaris-Navigation__Item--disabled": @disabled
    )
  end

  def selected_sub_items?
    return unless sub_items.present?

    sub_items.any?(&:selected)
  end

  class SecondaryActionComponent < Polaris::Component
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
          "Polaris-Navigation__SecondaryAction"
        )
      end
    end

    def call
      tag.span do
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
end
