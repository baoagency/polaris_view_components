require "test_helper"

class SpacerComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_vertical_spacer
    render_inline(Polaris::SpacerComponent.new(vertical: :base))

    assert_selector ".Polaris-Spacer.Polaris-Spacer--verticalSpacingBase"
  end

  def test_horizontal_spacer
    render_inline(Polaris::SpacerComponent.new(horizontal: :loose))

    assert_selector ".Polaris-Spacer.Polaris-Spacer--horizontalSpacingLoose"
  end
end
