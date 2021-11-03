require "test_helper"

class ScrollableComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_scrollable
    render_inline(Polaris::ScrollableComponent.new(height: "100px")) { "Content" }

    assert_selector '.Polaris-Scrollable.Polaris-Scrollable--vertical[style="height: 100px;"]' do
      assert_selector '[data-polaris-scrollable-target="topEdge"]'
      assert_text "Content"
      assert_selector '[data-polaris-scrollable-target="bottomEdge"]'
    end
  end

  def test_horizontal_scrollable
    render_inline(Polaris::ScrollableComponent.new(horizontal: true, width: "100px")) { "Content" }

    assert_selector '.Polaris-Scrollable--horizontal[style="width: 100px;"]'
  end

  def test_shadows
    render_inline(Polaris::ScrollableComponent.new(shadow: true)) { "Content" }
    assert_selector ".Polaris-Scrollable[data-polaris-scrollable-shadow-value=true]"

    render_inline(Polaris::ScrollableComponent.new(shadow: false)) { "Content" }
    assert_selector ".Polaris-Scrollable[data-polaris-scrollable-shadow-value=false]"
  end

  def test_focusable
    render_inline(Polaris::ScrollableComponent.new(focusable: true)) { "Content" }
    assert_selector ".Polaris-Scrollable[tabindex=0]"

    render_inline(Polaris::ScrollableComponent.new(focusable: false)) { "Content" }
    assert_no_selector ".Polaris-Scrollable[tabindex=0]"
  end
end
