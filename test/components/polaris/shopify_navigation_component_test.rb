require "test_helper"

class ShopifyNavigationComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_navigation
    render_inline(Polaris::ShopifyNavigationComponent.new) do |nav|
      nav.with_link(url: "/page1", active: true) { "Page 1" }
      nav.with_link(url: "/page2", target: "_blank") { "Page 2" }
    end

    assert_selector ".shp-Navigation > .Polaris-LegacyStack > ul.shp-Navigation_Items" do
      assert_selector "li.shp-Navigation_Item", count: 2
      assert_selector "li.shp-Navigation_Item:nth-child(1)" do
        assert_selector "a.shp-Navigation_Link[href='/page1']" do
          assert_selector "span.shp-Navigation_LinkText", text: "Page 1"
        end
      end
      assert_selector "li.shp-Navigation_Item:nth-child(2)" do
        assert_selector "a.shp-Navigation_Link[href='/page2'][target='_blank']" do
          assert_selector "span.shp-Navigation_LinkText", text: "Page 2"
        end
      end
    end
  end
end
