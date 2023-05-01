require "test_helper"

class CalloutCardComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_callout_card
    render_inline(Polaris::CalloutCardComponent.new(
      title: "Callout Title",
      illustration: "/image.png"
    )) do |callout|
      callout.with_primary_action(url: "#") { "Primary Action" }

      "Callout Text"
    end

    assert_selector ".Polaris-LegacyCard > .Polaris-CalloutCard__Container > .Polaris-LegacyCard__Section > .Polaris-CalloutCard" do
      assert_selector ".Polaris-CalloutCard__Content" do
        assert_selector ".Polaris-CalloutCard__Title", text: "Callout Title"
        assert_selector ".Polaris-TextContainer", text: "Callout Text"
        assert_selector ".Polaris-CalloutCard__Buttons" do
          assert_selector ".Polaris-Button", text: "Primary Action"
        end
      end
      assert_selector "img.Polaris-CalloutCard__Image[src='/image.png']"
    end
  end

  def test_callout_card_with_secondary_action
    render_inline(Polaris::CalloutCardComponent.new(title: "Callout Title")) do |callout|
      callout.with_primary_action(url: "#") { "Primary Action" }
      callout.with_secondary_action(url: "#") { "Secondary Action" }
    end

    assert_selector ".Polaris-CalloutCard__Buttons > .Polaris-ButtonGroup" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 2
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(1)" do
        assert_selector ".Polaris-Button", text: "Primary Action"
      end
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(2)" do
        assert_selector ".Polaris-Button--plain", text: "Secondary Action"
      end
    end
  end

  def test_dismissible_callout_card
    render_inline(Polaris::CalloutCardComponent.new(
      title: "Callout Title",
      illustration: "/image.png"
    )) do |callout|
      callout.with_dismiss_button(url: "#")
    end

    assert_selector ".Polaris-CalloutCard__Container.Polaris-CalloutCard--hasDismiss" do
      assert_selector ".Polaris-CalloutCard__Dismiss" do
        assert_selector ".Polaris-Button.Polaris-Button--plain.Polaris-Button--iconOnly"
      end
    end
  end
end
