class ButtonComponentPreview < ViewComponent::Preview
  # Button Component
  # ------------
  # Buttons are used primarily for actions, such as “Add”, “Close”, “Cancel”, or “Save”.
  # Plain buttons, which look similar to links, are used for less important or less commonly used actions,
  # such as “view shipping settings”.
  #
  # @param outline toggle "Gives the button a subtle alternative to the default button styling, appropriate for certain backdrops"
  # @param plain toggle "Renders a button that looks like a link"
  # @param primary toggle "Provides extra visual weight and identifies the primary action in a set of buttons"
  # @param pressed toggle "Sets the button in a pressed state"
  # @param monochrome toggle "Makes `plain` and `outline` Button colors (text, borders, icons) the same as the current text color. Also adds an underline to `plain` Buttons."
  # @param loading toggle "Replaces button text with a spinner while a background action is being performed"
  # @param destructive toggle "Indicates a dangerous or potentially negative action"
  # @param disabled toggle "Disables the button, disallowing merchant interaction"
  # @param disable_with_loader toggle "Disables the button and shows loading spinner on click"
  # @param disclosure select "Displays the button with a disclosure icon" {{Polaris::ButtonComponent::DISCLOSURE_OPTIONS}}
  # @param url text "Button acts as link"
  # @param external toggle "Forces url to open in a new tab"
  # @param full_width toggle "Allows the button to grow to the width of its container"
  # @param submit toggle "Allows the button to submit a form"
  # @param remove_underline toggle "Removes underline from button text (including on interaction) when `monochrome` and `plain` are true"
  # @param size select "Size of button" {{Polaris::ButtonComponent::SIZE_MAPPINGS.keys}}
  # @param text_align select "Position of text" {{Polaris::ButtonComponent::TEXT_ALIGN_MAPPINGS.keys}}
  # @param icon_name text "Adds icon to the button"
  def default(
    outline: false,
    plain: false,
    primary: false,
    pressed: false,
    monochrome: false,
    loading: false,
    destructive: false,
    disabled: false,
    disable_with_loader: false,
    disclosure: Polaris::ButtonComponent::DISCLOSURE_DEFAULT,
    url: nil,
    external: false,
    full_width: false,
    submit: false,
    remove_underline: false,
    size: Polaris::ButtonComponent::SIZE_DEFAULT,
    text_align: Polaris::ButtonComponent::TEXT_ALIGN_DEFAULT,
    icon_name: "CirclePlusMinor"
  )
    render_with_locals(binding)
  end

  def basic
  end

  # @param outline toggle "Gives the button a subtle alternative to the default button styling, appropriate for certain backdrops"
  def outline(outline: true)
    render_with_locals(binding)
  end

  # @param outline toggle "Gives the button a subtle alternative to the default button styling, appropriate for certain backdrops"
  # @param monochrome toggle "Makes `plain` and `outline` Button colors (text, borders, icons) the same as the current text color. Also adds an underline to `plain` Buttons."
  def outline_monochrome(outline: true, monochrome: true)
    render_with_locals(binding)
  end

  # @param plain toggle "Renders a button that looks like a link"
  def plain(plain: true)
    render_with_locals(binding)
  end

  # @param plain toggle "Renders a button that looks like a link"
  # @param monochrome toggle "Makes `plain` and `outline` Button colors (text, borders, icons) the same as the current text color. Also adds an underline to `plain` Buttons."
  def plain_monochrome(plain: true, monochrome: true)
    render_with_locals(binding)
  end

  # @param plain toggle "Renders a button that looks like a link"
  # @param monochrome toggle "Makes `plain` and `outline` Button colors (text, borders, icons) the same as the current text color. Also adds an underline to `plain` Buttons."
  # @param remove_underline toggle "Removes underline from button text (including on interaction) when `monochrome` and `plain` are true"
  def plain_monochrome_no_underline(plain: true, monochrome: true, remove_underline: true)
    render_with_locals(binding)
  end

  # @param plain toggle "Renders a button that looks like a link"
  # @param destructive toggle "Indicates a dangerous or potentially negative action"
  def plain_destructive(plain: true, destructive: true)
    render_with_locals(binding)
  end

  # @param primary toggle "Provides extra visual weight and identifies the primary action in a set of buttons"
  def primary(primary: true)
    render_with_locals(binding)
  end

  # @param destructive toggle "Indicates a dangerous or potentially negative action"
  def destructive(destructive: true)
    render_with_locals(binding)
  end

  # @param size select "Size of button" {{Polaris::ButtonComponent::SIZE_MAPPINGS.keys}}
  def slim(size: :slim)
    render_with_locals(binding)
  end

  # @param size select "Size of button" {{Polaris::ButtonComponent::SIZE_MAPPINGS.keys}}
  def large(size: :large)
    render_with_locals(binding)
  end

  # @param full_width toggle "Allows the button to grow to the width of its container"
  def full_width(full_width: true)
    render_with_locals(binding)
  end

  # @param plain toggle "Renders a button that looks like a link"
  # @param text_align select "Position of text" {{Polaris::ButtonComponent::TEXT_ALIGN_MAPPINGS.keys}}
  def text_aligned(plain: true, text_align: :left)
    render_with_locals(binding)
  end

  # @param pressed toggle "Sets the button in a pressed state"
  def pressed(pressed: true)
    render_with_locals(binding)
  end

  # @param disclosure select "Displays the button with a disclosure icon" {{Polaris::ButtonComponent::DISCLOSURE_OPTIONS}}
  def disclosure(disclosure: :up)
    render_with_locals(binding)
  end

  # @param disabled toggle "Disables the button, disallowing merchant interaction"
  def disabled(disabled: true)
    render_with_locals(binding)
  end

  def disable_with_actions
  end

  # @param disable_with_loader toggle "Disables the button and shows loading spinner on click"
  def disable_with_loader(disable_with_loader: true)
    render_with_locals(binding)
  end

  # @param loading toggle "Replaces button text with a spinner while a background action is being performed"
  def loading(loading: true)
    render_with_locals(binding)
  end

  def text_with_icon
  end

  # @param url text "Button acts as link"
  def icon_only(url: "https://shopify.com")
    render_with_locals(binding)
  end

  # @param icon_name text "Adds icon to the button"
  def with_icon_name(icon_name: "CirclePlusMajor")
    render_with_locals(binding)
  end

  # @param url text "Button acts as link"
  # @param external toggle "Forces url to open in a new tab"
  def external(url: "https://shopify.dev", external: true)
    render_with_locals(binding)
  end
end
