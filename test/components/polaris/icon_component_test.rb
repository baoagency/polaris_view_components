require "test_helper"

class IconComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_icon
    render_inline(Polaris::IconComponent.new(name: "PlusCircleIcon"))

    assert_selector "span.Polaris-Icon" do
      assert_selector "svg.Polaris-Icon__Svg"
    end
  end

  def test_renders_colored_icon
    render_inline(Polaris::IconComponent.new(name: "PlusCircleIcon", color: :critical))

    assert_selector "span.Polaris-Icon.Polaris-Icon--colorCritical.Polaris-Icon--applyColor" do
      assert_selector "svg.Polaris-Icon__Svg"
    end
  end

  def test_renders_icon_with_backdrop
    render_inline(Polaris::IconComponent.new(name: "PlusCircleIcon", backdrop: true))

    assert_selector "span.Polaris-Icon.Polaris-Icon--hasBackdrop" do
      assert_selector "svg.Polaris-Icon__Svg"
    end
  end

  def test_renders_user_icon
    render_inline(Polaris::IconComponent.new) do
      "Custom Icon"
    end

    assert_selector "span.Polaris-Icon", text: "Custom Icon"
  end
end
