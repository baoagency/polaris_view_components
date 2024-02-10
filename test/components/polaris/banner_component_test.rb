require "test_helper"

class BannerComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_banner
    render_inline(Polaris::BannerComponent.new(title: "Banner Header")) do
      "Banner Content"
    end

    assert_selector ".Polaris-Banner.Polaris-Banner--withinPage" do
      assert_selector ".Polaris-Icon.Polaris-Icon--colorBase.Polaris-Icon--applyColor"
      assert_selector ".Polaris-Banner__ContentWrapper" do
        assert_text "Banner Header"
        assert_text "Banner Content"
      end
    end
  end

  def test_dismissible_banner
    render_inline(Polaris::BannerComponent.new) do |banner|
      banner.with_dismiss_button(url: "#")
      "Banner Content"
    end

    assert_selector ".Polaris-Banner" do
      assert_selector ".Polaris-Banner__DismissButton > .Polaris-Button.Polaris-Button--plain.Polaris-Button--iconOnly"
    end
  end

  def test_banner_with_actions
    render_inline(Polaris::BannerComponent.new) do |banner|
      banner.with_action(url: "/primary") { "Primary Action" }
      banner.with_secondary_action(url: "/secondary") { "Secondary Action" }
    end

    assert_selector ".Polaris-Banner .Polaris-Banner__ContentWrapper" do
      assert_selector ".Polaris-ButtonGroup" do
        assert_selector ".Polaris-ButtonGroup__Item", count: 2
        assert_selector ".Polaris-ButtonGroup__Item:nth-child(1)" do
          assert_selector "a.Polaris-Button[href='/primary']", text: "Primary Action"
        end
        assert_selector ".Polaris-ButtonGroup__Item:nth-child(2)" do
          assert_selector "a.Polaris-Button[href='/secondary']", text: "Secondary Action"
        end
      end
    end
  end

  def test_informational_banner
    render_inline(Polaris::BannerComponent.new(status: :info)) do
      "Banner Content"
    end

    assert_selector ".Polaris-Banner.Polaris-Banner--statusInfo"
  end

  def test_sucess_banner
    render_inline(Polaris::BannerComponent.new(status: :success)) do
      "Banner Content"
    end

    assert_selector ".Polaris-Banner.Polaris-Banner--statusSuccess"
  end

  def test_warning_banner
    render_inline(Polaris::BannerComponent.new(status: :warning)) do
      "Banner Content"
    end

    assert_selector ".Polaris-Banner.Polaris-Banner--statusWarning"
  end

  def test_critical_banner
    render_inline(Polaris::BannerComponent.new(status: :critical)) do
      "Banner Content"
    end

    assert_selector ".Polaris-Banner.Polaris-Banner--statusCritical"
  end

  def test_banner_within_container
    render_inline(Polaris::BannerComponent.new(within: :container)) do
      "Banner Content"
    end

    assert_selector ".Polaris-Banner.Polaris-Banner--withinContentContainer"
  end
end
