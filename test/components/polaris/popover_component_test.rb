require "test_helper"

class PopoverComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_popover
    render_inline(Polaris::PopoverComponent.new) do |popover|
      popover.with_button { "Activator" }
      "Content"
    end

    assert_selector '[data-controller="polaris-popover"]' do
      assert_selector '[data-polaris-popover-target="activator"]' do
        assert_selector 'button.Polaris-Button[data-action~="polaris-popover#toggle"]', text: "Activator"
      end
      assert_selector ".Polaris-PositionedOverlay.Polaris-Popover__PopoverOverlay--closed" do
        assert_selector ".Polaris-Popover .Polaris-Popover__Content" do
          assert_selector ".Polaris-Popover__Pane.Polaris-Scrollable", text: "Content"
        end
      end
    end
  end

  def test_custom_activator
    render_inline(Polaris::PopoverComponent.new) do |popover|
      popover.with_activator do
        tag.p "Activator"
      end
      "Content"
    end

    assert_selector '[data-polaris-popover-target="activator"]' do
      assert_selector "p", text: "Activator"
    end
  end

  def test_fixed_panes
    render_inline(Polaris::PopoverComponent.new) do |popover|
      popover.with_pane(fixed: true) do
        "Content"
      end
    end

    assert_selector ".Polaris-Popover__Content > .Polaris-Popover__Pane.Polaris-Popover__Pane--fixed" do
      assert_text "Content"
    end
  end

  def test_sectioned
    render_inline(Polaris::PopoverComponent.new(sectioned: true)) do |popover|
      "Content"
    end

    assert_selector ".Polaris-Popover__Content > .Polaris-Popover__Pane > .Polaris-Popover__Section" do
      assert_text "Content"
    end
  end

  def test_sectioned_panes
    render_inline(Polaris::PopoverComponent.new) do |popover|
      popover.with_pane(sectioned: true) do
        "Content"
      end
    end

    assert_selector ".Polaris-Popover__Content > .Polaris-Popover__Pane > .Polaris-Popover__Section" do
      assert_text "Content"
    end
  end

  def test_multiple_sections
    render_inline(Polaris::PopoverComponent.new) do |popover|
      popover.with_pane do |pane|
        pane.with_section { "Section 1" }
        pane.with_section { "Section 2" }
      end
    end

    assert_selector ".Polaris-Popover__Pane" do
      assert_selector ".Polaris-Popover__Section", count: 2
      assert_selector ".Polaris-Popover__Section:nth-of-type(1)", text: "Section 1"
      assert_selector ".Polaris-Popover__Section:nth-of-type(2)", text: "Section 2"
    end
  end
end
