module ActionHelper
  class Action
    attr_reader :content

    def initialize(
      content:,
      url:,
      accessibility_label: '',
      external: false,
      id: '',
      data: {}
    )
      @content = content
      @accessibility_label = accessibility_label
      @external = external
      @id = id
      @url = url
      @data = data
    end

    def to_h
      {
        content: @content,
        accessibility_label: @accessibility_label,
        external: @external,
        id: @id,
        url: @url,
        data: @data,
      }
    end
  end

  class ComplexAction
    attr_reader :content

    def initialize(
      content:,
      accessibility_label: '',
      destructive: false,
      disabled: false,
      external: false,
      id: '',
      loading: false,
      outline: false,
      submit: false,
      url: ''
    )
      @content = content
      @accessibility_label = accessibility_label
      @destructive = destructive
      @disabled = disabled
      @external = external
      @id = id
      @loading = loading
      @outline = outline
      @submit = submit
      @url = url
    end

    def to_h
      {
        content: @content,
        accessibility_label: @accessibility_label,
        destructive: @destructive,
        disabled: @disabled,
        external: @external,
        id: @id,
        loading: @loading,
        outline: @outline,
        submit: @submit,
        url: @url,
      }
    end
  end

  def action(**args)
    Action.new(**args)
  end

  def complex_action(**args)
    ComplexAction.new(**args)
  end

  def render_action(action)
    render Polaris::Button::Component.new(**action.to_h.except(:content)) do
      action.content
    end
  end

  def render_plain_action(action)
    render Polaris::Button::Component.new(**action.to_h.except(:content), plain: true) do
      action.content
    end
  end

  def render_complex_action_button(complex_action)
    render Polaris::Button::Component.new(**complex_action.to_h.except(:content)) do
      complex_action.content
    end
  end

  def render_primary_complex_action_button(complex_action)
    render Polaris::Button::Component.new({ **complex_action.to_h.except(:content), primary: true }) do
      complex_action.content
    end
  end

  def render_plain_complex_action_button(complex_action)
    render Polaris::Button::Component.new({ **complex_action.to_h.except(:content), plain: true }) do
      complex_action.content
    end
  end
end
