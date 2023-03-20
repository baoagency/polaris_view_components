require "test_helper"

class SaveBarComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_save_bar
    render_inline(Polaris::FrameComponent.new(logo: {
      src: "http://example.com/logo.jpg"
    })) do |frame|
      frame.save_bar(message: "Message") do |save_bar|
        save_bar.save_action { "Save" }
        save_bar.discard_action { "Discard" }
      end
    end

    assert_selector ".Polaris-Frame > .Polaris-Frame__ContextualSaveBar" do
      assert_selector ".Polaris-Frame-ContextualSaveBar" do
        assert_selector ".Polaris-Frame-ContextualSaveBar__LogoContainer" do
          assert_selector "img[src='http://example.com/logo.jpg']"
        end
        assert_selector ".Polaris-Frame-ContextualSaveBar__Contents" do
          assert_selector "h2.Polaris-Frame-ContextualSaveBar__Message", text: "Message"
          assert_selector ".Polaris-Frame-ContextualSaveBar__ActionContainer > .Polaris-LegacyStack" do
            assert_selector ".Polaris-LegacyStack__Item > .Polaris-Button", text: "Discard"
            assert_selector ".Polaris-LegacyStack__Item > .Polaris-Button--primary", text: "Save"
          end
        end
      end
    end
  end

  def test_full_width
    render_inline(Polaris::FrameComponent.new) do |frame|
      frame.save_bar(message: "Message", full_width: true) do |save_bar|
        save_bar.save_action { "Save" }
        save_bar.discard_action { "Discard" }
      end
    end

    assert_selector ".Polaris-Frame-ContextualSaveBar__Contents.Polaris-Frame-ContextualSaveBar--fullWidth"
  end
end
