require "test_helper"

class TooltipComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default
    render_inline(Polaris::TooltipComponent.new(text: "Tooltip")) { "Hover on me" }

    assert_selector '[data-controller="polaris-tooltip"]', visible: false do
      assert_text "Hover on me"

      assert_selector '[data-polaris-tooltip-target="template"]', visible: false
    end
  end
end
