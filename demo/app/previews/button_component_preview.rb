class ButtonComponentPreview < ViewComponent::Preview
  def basic
  end

  def outline
  end

  def outline_monochrome
  end

  def plain
  end

  def plain_monochrome
  end

  def plain_monochrome_no_underline
  end

  def plain_destructive
  end

  def primary
  end

  def primary_destructive
  end

  def destructive
  end

  def slim
  end

  def large
  end

  def full_width
  end

  def text_aligned
  end

  def pressed
  end

  def disclosure
  end

  def disabled
  end

  def disable_with_actions
  end

  def disable_with_loader
  end

  def loading
  end

  def text_with_icon
  end

  def icon_only
  end

  def with_icon_name
  end

  def external
  end

  def with_tooltip
  end

  # @label Playground
  # @param button_label text "Button label"
  # @param url url "Button URL"
  # @param icon_name text "Polaris icon name"
  # @param tooltip text "Tooltip text"
  # @param size select "Button size" {{Polaris::HeadlessButton::SIZE_OPTIONS}}
  # @param text_align select "Text alignment" {{Polaris::HeadlessButton::TEXT_ALIGN_OPTIONS}}
  # @param disclosure select "Disclosure icon" {{Polaris::HeadlessButton::DISCLOSURE_OPTIONS}}
  # @param primary toggle "Primary style"
  # @param destructive toggle "Destructive style"
  # @param plain toggle "Plain style"
  # @param outline toggle "Outline style"
  # @param monochrome toggle "Monochrome style"
  # @param pressed toggle "Pressed state"
  # @param full_width toggle "Full width"
  # @param external toggle "Open in new tab"
  # @param submit toggle "Submit button type"
  # @param disabled toggle "Disable the button"
  # @param loading toggle "Show loading spinner"
  # @param disable_with_loader toggle "Disable on click with loader"
  # @param remove_underline toggle "Remove underline (plain + monochrome)"
  def playground(
    button_label: "Add product",
    url: "https://shopify.com",
    icon_name: "PlusCircleIcon",
    tooltip: "Add product",
    size: Polaris::HeadlessButton::SIZE_DEFAULT,
    text_align: Polaris::HeadlessButton::TEXT_ALIGN_DEFAULT,
    disclosure: Polaris::HeadlessButton::DISCLOSURE_DEFAULT,
    primary: false,
    destructive: false,
    plain: false,
    outline: false,
    monochrome: false,
    pressed: false,
    full_width: false,
    external: false,
    submit: false,
    disabled: false,
    loading: false,
    disable_with_loader: false,
    remove_underline: false
  )
    render_with_template(locals: {
      button_label: button_label,
      url: url,
      icon_name: icon_name,
      tooltip: tooltip,
      size: size,
      text_align: text_align,
      disclosure: disclosure,
      primary: primary,
      destructive: destructive,
      plain: plain,
      outline: outline,
      monochrome: monochrome,
      pressed: pressed,
      full_width: full_width,
      external: external,
      submit: submit,
      disabled: disabled,
      loading: loading,
      disable_with_loader: disable_with_loader,
      remove_underline: remove_underline,
    })
  end
end
