require "test_helper"

class NavigationListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_navigation
    render_inline(Polaris::NavigationListComponent.new) do |navigation|
      navigation.with_item(url: "/path1", label: "Item 1", icon: "HomeIcon")
      navigation.with_item(url: "/path2", label: "Item 2", icon: "OrderIcon", selected: true)
    end

    assert_selector "div.Polaris-LegacyCard" do
      assert_selector "li.Polaris-Navigation__ListItem" do
        assert_selector "div.Polaris-Navigation__ItemWrapper" do
          assert_selector "div.Polaris-Navigation__ItemInnerWrapper" do
            assert_selector "a.Polaris-Navigation__Item[href='/path1']" do
              assert_selector "div.Polaris-Navigation__Icon" do
                assert_selector "span.Polaris-Icon" do
                  assert_selector "svg.Polaris-Icon__Svg"
                end
              end
            end
          end
        end
      end
    end
  end
end
