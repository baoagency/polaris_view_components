require "test_helper"

class NavigationListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_navigation
    render_inline(Polaris::NavigationListComponent.new) do |navigation|
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeMajor")
      navigation.with_item(url: "/path2", label: "Item 2", icon: "OrdersMajor")
    end

    assert_selector "nav.Polaris-Navigation > .Polaris-Navigation__PrimaryNavigation.Polaris-Scrollable" do
      assert_selector "ul.Polaris-Navigation__Section" do
        assert_selector "li.Polaris-Navigation__ListItem", count: 2
        assert_selector "li:nth-child(1)" do
          assert_selector ".Polaris-Navigation__ItemWrapper" do
            assert_selector "a.Polaris-Navigation__Item[href='/path1']" do
              assert_selector ".Polaris-Navigation__Icon > .Polaris-Icon"
              assert_selector ".Polaris-Navigation__Text", text: "Item 1"
            end
          end
        end
        assert_selector "li:nth-child(2)" do
          assert_selector ".Polaris-Navigation__ItemWrapper" do
            assert_selector "a.Polaris-Navigation__Item[href='/path2']" do
              assert_selector ".Polaris-Navigation__Icon > .Polaris-Icon"
              assert_selector ".Polaris-Navigation__Text", text: "Item 2"
            end
          end
        end
      end
    end
  end

  def test_selected_items
    render_inline(Polaris::NavigationListComponent.new) do |navigation|
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeMajor", selected: true)
      navigation.with_item(url: "/path1", label: "Item 2", icon: "HomeMajor") do |item|
        item.with_sub_item(url: "#", label: "Sub Item", selected: true)
      end
    end

    assert_selector ".Polaris-Navigation__Item.Polaris-Navigation__Item--selected.Polaris-Navigation--subNavigationActive" do
      assert_text "Item 1"
    end
    assert_selector ".Polaris-Navigation__Item.Polaris-Navigation--subNavigationActive" do
      assert_text "Item 2"
      assert_selector ".Polaris-Navigation__Item.Polaris-Navigation__Item--selected.Polaris-Navigation--subNavigationActive" do
        assert_text "Sub Item"
      end
    end
  end
end
