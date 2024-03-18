require "test_helper"

class FrameComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_frame
    render_inline(Polaris::FrameComponent.new(logo: {
      url: "/root_url",
      src: "http://example.com/logo.jpg"
    })) do |frame|
      frame.with_top_bar do |top_bar|
        top_bar.with_user_menu(name: "Kirill", detail: "Platmart") do |user_menu|
          user_menu.with_avatar(initials: "K")
          "Popover Content"
        end
      end
      frame.with_navigation do |navigation|
        navigation.with_item(url: "#", label: "Home", icon: "HomeIcon")
      end
      frame.with_save_bar(message: "SaveBar Message") do |save_bar|
        save_bar.with_save_action { "Save" }
        save_bar.with_discard_action { "Discard" }
      end

      "Frame Content"
    end

    assert_selector ".Polaris-Frame" do
      assert_selector ".Polaris-Frame__TopBar" do
        assert_text "Popover Content"
      end
      assert_selector ".Polaris-Frame__Navigation" do
        assert_selector ".Polaris-Navigation" do
          assert_text "Home"
        end
        assert_selector ".Polaris-Frame__NavigationDismiss"
      end
      assert_selector ".Polaris-Frame-ContextualSaveBar" do
        assert_text "SaveBar Message"
      end

      assert_selector ".Polaris-Frame__Main > .Polaris-Frame__Content" do
        assert_text "Frame Content"
      end
    end
  end
end
