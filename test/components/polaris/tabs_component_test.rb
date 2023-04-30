require "test_helper"

class TabsComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_tabs
    render_inline(Polaris::TabsComponent.new) do |tabs|
      tabs.with_tab(title: "Active", active: true)
      tabs.with_tab(title: "With URL", url: "https://shopify.dev")
    end

    assert_selector ".Polaris-LegacyTabs__Wrapper > ul.Polaris-LegacyTabs" do
      assert_selector "li.Polaris-LegacyTabs__TabContainer", count: 2
      assert_selector "li:nth-of-type(1)" do
        assert_selector "button.Polaris-LegacyTabs__Tab.Polaris-LegacyTabs__Tab--selected" do
          assert_selector "span.Polaris-LegacyTabs__Title", text: "Active"
        end
      end
      assert_selector "li:nth-of-type(2)" do
        assert_selector %(a.Polaris-LegacyTabs__Tab[href="https://shopify.dev"]), text: "With URL"
      end
    end
  end

  def test_fitted_tabs
    render_inline(Polaris::TabsComponent.new(fitted: true)) do |tabs|
      tabs.with_tab(title: "Default")
    end

    assert_selector "ul.Polaris-LegacyTabs.Polaris-LegacyTabs--fitted"
  end

  def test_tabs_with_badge
    render_inline(Polaris::TabsComponent.new(fitted: true)) do |tabs|
      tabs.with_tab(title: "Default") do |tab|
        tab.with_badge { "100" }
      end
    end

    assert_selector ".Polaris-LegacyTabs__Tab > span.Polaris-LegacyTabs__Title" do
      assert_text "Default"
      assert_selector "span.Polaris-Badge", text: 100
    end
  end
end
