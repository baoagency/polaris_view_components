require "test_helper"

class TextContainerComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_text
    render_inline(Polaris::TextContainerComponent.new) { "Content" }

    assert_selector "div.Polaris-TextContainer", text: "Content"
  end

  def test_tight_text
    render_inline(Polaris::TextContainerComponent.new(spacing: :tight)) { "Content" }

    assert_selector ".Polaris-TextContainer--spacingTight"
  end

  def test_loose_text
    render_inline(Polaris::TextContainerComponent.new(spacing: :loose)) { "Content" }

    assert_selector ".Polaris-TextContainer--spacingLoose"
  end
end
