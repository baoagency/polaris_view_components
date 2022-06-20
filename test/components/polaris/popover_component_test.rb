require "test_helper"

class PopoverComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_popover
    render_inline(Polaris::PopoverComponent.new) do |popover|
      popover.button { "Activator" }
      "Content"
    end

    assert_selector '[data-controller="polaris-popover"]' do
      assert_selector '[data-polaris-popover-target="activator"]' do
        assert_selector 'button.Polaris-Button[data-action~="polaris-popover#toggle"]', text: "Activator"
      end
    end
  end

  def test_custom_activator
    render_inline(Polaris::PopoverComponent.new) do |popover|
      popover.activator do
        tag.p "Activator"
      end
      "Content"
    end

    assert_selector '[data-polaris-popover-target="activator"]' do
      assert_selector "p", text: "Activator"
    end
  end
end
