require "test_helper"

class TopBarComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_top_bar
    render_inline(Polaris::FrameComponent.new(logo: {
      url: "/root_url",
      src: "http://example.com/logo.jpg"
    })) do |frame|
      frame.top_bar do |top_bar|
        top_bar.user_menu(name: "Name", detail: "Detail") do |user_menu|
          user_menu.avatar(initials: "K")
          "Popover Content"
        end
      end
    end

    assert_selector ".Polaris-Frame > .Polaris-Frame__TopBar > .Polaris-TopBar" do
      assert_selector "button.Polaris-TopBar__NavigationIcon > .Polaris-Icon"
      assert_selector ".Polaris-TopBar__LogoContainer" do
        assert_selector "a.Polaris-TopBar__LogoLink[href='/root_url']" do
          assert_selector "img.Polaris-TopBar__Logo[src='http://example.com/logo.jpg']"
        end
      end
      assert_selector ".Polaris-TopBar__Contents" do
        assert_selector ".Polaris-TopBar-Menu__ActivatorWrapper" do
          assert_selector ".Polaris-TopBar-Menu__Activator" do
            assert_selector ".Polaris-MessageIndicator__MessageIndicatorWrapper > .Polaris-Avatar"
            assert_selector ".Polaris-TopBar-UserMenu__Details" do
              assert_selector ".Polaris-TopBar-UserMenu__Name", text: "Name"
              assert_selector ".Polaris-TopBar-UserMenu__Detail", text: "Detail"
            end
          end
        end
      end
    end
  end
end
