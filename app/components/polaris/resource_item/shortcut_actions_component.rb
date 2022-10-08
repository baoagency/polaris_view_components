class Polaris::ResourceItem::ShortcutActionsComponent < Polaris::Component
  renders_many :buttons, ->(**system_arguments) do
    ShortcutActionsButtonComponent.new(
      persist_actions: @persist_actions,
      **system_arguments
    )
  end

  def initialize(
    persist_actions: false,
    wrapper_arguments: {},
    disclosure_arguments: {},
    popover_arguments: {},
    **system_arguments
  )
    @persist_actions = persist_actions
    @wrapper_arguments = wrapper_arguments
    @disclosure_arguments = disclosure_arguments
    @popover_arguments = popover_arguments
    @system_arguments = system_arguments
  end

  def wrapper_arguments
    @wrapper_arguments.tap do |opts|
      opts[:tag] = "div"
      opts[:classes] = class_names(
        @wrapper_arguments[:classes],
        "Polaris-ResourceItem__Actions"
      )
    end
  end

  def disclosure_arguments
    @disclosure_arguments.tap do |opts|
      opts[:tag] = "div"
      opts[:classes] = class_names(
        @disclosure_arguments[:classes],
        "Polaris-ResourceItem__Disclosure"
      )
    end
  end

  def popover_arguments
    {
      alignment: :right,
      position: :below,
      append_to_body: true
    }.deep_merge(@popover_arguments)
  end

  def system_arguments
    @system_arguments.tap do |opts|
      opts[:segmented] = !@persist_actions
    end
  end

  class ShortcutActionsButtonComponent < Polaris::Component
    attr_reader :content

    def initialize(
      url:,
      content:,
      persist_actions:,
      action_list_item_arguments: {},
      **system_arguments
    )
      @url = url
      @content = content
      @persist_actions = persist_actions
      @action_list_item_arguments = action_list_item_arguments
      @system_arguments = system_arguments
    end

    def system_arguments
      @system_arguments.tap do |opts|
        opts[:url] = @url
        opts[:size] = :slim unless @persist_actions
        opts[:plain] = true if @persist_actions
      end
    end

    def action_list_item_arguments
      @action_list_item_arguments.tap do |opts|
        opts[:url] = @url
      end
    end
  end
end
