require "test_helper"

class NavigationComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_navigation
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon")
      navigation.with_item(url: "/path2", label: "Item 2", icon: "OrderIcon")
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
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon", badge: "BADGE")
    end

    assert_selector ".Polaris-Navigation__ListItem .Polaris-Navigation__Item" do
      assert_selector ".Polaris-Navigation__Badge > .Polaris-Badge", text: "BADGE"
    end
  end

  def test_multiple_sections
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.with_section do |section|
        section.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon")
      end
      navigation.with_section do |section|
        navigation.with_item(url: "/path2", label: "Item 2", icon: "OrderIcon")
      end
    end

    assert_selector ".Polaris-Navigation" do
      assert_selector "ul.Polaris-Navigation__Section", count: 2
    end
  end

  def test_section_heading
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.with_section(title: "SECTION_TITLE") do |section|
        section.with_action(url: "/action", icon: "PlusCircleIcon")
        section.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon")
      end
    end

    assert_selector ".Polaris-Navigation__Section" do
      assert_selector "li.Polaris-Navigation__SectionHeading" do
        assert_selector "div", text: "SECTION_TITLE"
        assert_selector "a.Polaris-Navigation__Action[href='/action']"
      end
    end
  end

  def test_sub_items
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon") do |item|
        item.with_sub_item(url: "/sub_item", label: "Sub Item")
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
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon", selected: true)
      navigation.with_item(url: "/path1", label: "Item 2", icon: "HomeIcon") do |item|
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

  def test_disabled_items
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon", disabled: true)
      navigation.with_item(url: "/path1", label: "Item 2", icon: "HomeIcon") do |item|
        item.with_sub_item(url: "#", label: "Sub Item", disabled: true)
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

  def test_external_items
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon", extenral: true)
      navigation.with_item(url: "/path1", label: "Item 2", icon: "HomeIcon") do |item|
        item.with_sub_item(url: "#", label: "Sub Item", external: true)
      end
    end

    assert_selector ".Polaris-Navigation__Item[target='_blank']" do
      assert_text "Item 1"
    end
    assert_selector ".Polaris-Navigation__Item" do
      assert_text "Item 2"
      assert_selector ".Polaris-Navigation__Item[target='_blank']" do
        assert_text "Sub Item"
      end
    end
  end

  def test_secondary_action
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon") do |item|
        item.with_secondary_action(url: "#", icon: "PlusCircleIcon")
      end
    end

    assert_selector ".Polaris-Navigation__ItemWrapper" do
      assert_selector "a.Polaris-Navigation__SecondaryAction > .Polaris-Icon"
    end
  end

  def test_section_separator
    render_inline(Polaris::NavigationComponent.new) do |navigation|
      navigation.with_section(separator: true) do |section|
        section.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon")
      end
    end

    assert_selector ".Polaris-Navigation__Section.Polaris-Navigation__Section--withSeparator"
  end
end
