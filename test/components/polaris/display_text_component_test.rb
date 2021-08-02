require "test_helper"

class DisplayTextComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_display_text
    render_inline(Polaris::DisplayTextComponent.new) { "Display Text" }

    assert_selector "p.Polaris-DisplayText.Polaris-DisplayText--sizeMedium", text: "Display Text"
  end

  def test_small_display_text
    render_inline(Polaris::DisplayTextComponent.new(size: :small)) { "Display Text" }

    assert_selector "p.Polaris-DisplayText--sizeSmall"
  end

  def test_h1_display_text
    render_inline(Polaris::DisplayTextComponent.new(element: :h1)) { "Display Text" }

    assert_selector "h1.Polaris-DisplayText", text: "Display Text"
  end
end
