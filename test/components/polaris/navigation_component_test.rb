require "test_helper"

class NavigationComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_navigation
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.item(url: "/path1", label: "Item 1", icon: "HomeMajor")
      navigation.item(url: "/path2", label: "Item 2", icon: "OrdersMajor")
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

  def test_item_badge
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.item(url: "/path1", label: "Item 1", icon: "HomeMajor", badge: "BADGE")
    end

    assert_selector ".Polaris-Navigation__ListItem .Polaris-Navigation__Item" do
      assert_selector ".Polaris-Navigation__Badge > .Polaris-Badge", text: "BADGE"
    end
  end

  def test_multiple_sections
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.section do |section|
        section.item(url: "/path1", label: "Item 1", icon: "HomeMajor")
      end
      navigation.section do |section|
        navigation.item(url: "/path2", label: "Item 2", icon: "OrdersMajor")
      end
    end

    assert_selector ".Polaris-Navigation" do
      assert_selector "ul.Polaris-Navigation__Section", count: 2
    end
  end

  def test_section_heading
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.section(title: "SECTION_TITLE") do |section|
        section.action(url: "/action", icon: "CirclePlusOutlineMinor")
        section.item(url: "/path1", label: "Item 1", icon: "HomeMajor")
      end
    end

    assert_selector ".Polaris-Navigation__Section" do
      assert_selector "li.Polaris-Navigation__SectionHeading" do
        assert_selector ".Polaris-Navigation__Text", text: "SECTION_TITLE"
        assert_selector "a.Polaris-Navigation__Action[href='/action']"
      end
    end
  end

  def test_sub_items
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.item(url: "/path1", label: "Item 1", icon: "HomeMajor") do |item|
        item.sub_item(url: "/sub_item", label: "Sub Item")
      end
    end

    assert_selector "li.Polaris-Navigation__ListItem" do
      assert_selector ".Polaris-Navigation__SecondaryNavigation.Polaris-Navigation--isExpanded" do
        assert_selector ".Polaris-Collapsible > .Polaris-Navigation__List" do
          assert_selector "li.Polaris-Navigation__ListItem", text: "Sub Item"
        end
      end
    end
  end

  def test_selected_items
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.item(url: "/path1", label: "Item 1", icon: "HomeMajor", selected: true)
      navigation.item(url: "/path1", label: "Item 2", icon: "HomeMajor") do |item|
        item.sub_item(url: "#", label: "Sub Item", selected: true)
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

  def test_disabled_items
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.item(url: "/path1", label: "Item 1", icon: "HomeMajor", disabled: true)
      navigation.item(url: "/path1", label: "Item 2", icon: "HomeMajor") do |item|
        item.sub_item(url: "#", label: "Sub Item", disabled: true)
      end
    end

    assert_selector ".Polaris-Navigation__Item.Polaris-Navigation__Item--disabled" do
      assert_text "Item 1"
    end
    assert_selector ".Polaris-Navigation__Item" do
      assert_text "Item 2"
      assert_selector ".Polaris-Navigation__Item.Polaris-Navigation__Item--disabled" do
        assert_text "Sub Item"
      end
    end
  end

  def test_secondary_action
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.item(url: "/path1", label: "Item 1", icon: "HomeMajor") do |item|
        item.secondary_action(url: "#", icon: "CirclePlusOutlineMinor")
      end
    end

    assert_selector ".Polaris-Navigation__ItemWrapper" do
      assert_selector "a.Polaris-Navigation__SecondaryAction > .Polaris-Icon"
    end
  end

  def test_section_separator
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.section(separator: true) do |section|
        section.item(url: "/path1", label: "Item 1", icon: "HomeMajor")
      end
    end

    assert_selector ".Polaris-Navigation__Section.Polaris-Navigation__Section--withSeparator"
  end
end
