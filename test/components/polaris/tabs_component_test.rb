require "test_helper"

class TabsComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_tabs
    render_inline(Polaris::TabsComponent.new) do |tabs|
      tabs.tab(title: "Active", active: true)
      tabs.tab(title: "With URL", url: "https://shopify.dev")
    end

    assert_selector ".Polaris-Tabs__Wrapper > ul.Polaris-Tabs" do
      assert_selector "li.Polaris-Tabs__TabContainer", count: 2
      assert_selector "li:nth-of-type(1)" do
        assert_selector "button.Polaris-Tabs__Tab.Polaris-Tabs__Tab--selected" do
          assert_selector "span.Polaris-Tabs__Title", text: "Active"
        end
      end
      assert_selector "li:nth-of-type(2)" do
        assert_selector %(a.Polaris-Tabs__Tab[href="https://shopify.dev"]), text: "With URL"
      end
    end
  end

  def test_fitted_tabs
    render_inline(Polaris::TabsComponent.new(fitted: true)) do |tabs|
      tabs.tab(title: "Default")
    end

    assert_selector "ul.Polaris-Tabs.Polaris-Tabs--fitted"
  end

  def test_tabs_with_badge
    render_inline(Polaris::TabsComponent.new(fitted: true)) do |tabs|
      tabs.tab(title: "Default") do |tab|
        tab.badge { "100" }
      end
    end

    assert_selector ".Polaris-Tabs__Tab > span.Polaris-Tabs__Title" do
      assert_text "Default"
      assert_selector "span.Polaris-Badge", text: 100
    end
  end
end
