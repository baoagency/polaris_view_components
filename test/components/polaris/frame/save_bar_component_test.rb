require "test_helper"

class SaveBarComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_save_bar
    render_inline(Polaris::FrameComponent.new(logo: {
      src: "http://example.com/logo.jpg"
    })) do |frame|
      frame.with_save_bar(message: "Message") do |save_bar|
        save_bar.with_save_action { "Save" }
        save_bar.with_discard_action { "Discard" }
      end
    end

    assert_selector ".Polaris-Frame > .Polaris-Frame__ContextualSaveBar" do
      assert_selector ".Polaris-Frame-ContextualSaveBar" do
        assert_selector ".Polaris-Frame-ContextualSaveBar__LogoContainer" do
          assert_selector "img[src='http://example.com/logo.jpg']"
        end
        assert_selector ".Polaris-Frame-ContextualSaveBar__Contents" do
          assert_selector "h2", text: "Message"
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
      frame.with_save_bar(message: "Message", full_width: true) do |save_bar|
        save_bar.with_save_action { "Save" }
        save_bar.with_discard_action { "Discard" }
      end
    end

    assert_selector ".Polaris-Frame-ContextualSaveBar__Contents.Polaris-Frame-ContextualSaveBar--fullWidth"
  end
end
