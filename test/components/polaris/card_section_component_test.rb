require "test_helper"

class CardSectionComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_top_border
    render_inline(Polaris::Card::SectionComponent.new(border_top: true))

    assert_selector ".Polaris-Card__Section.Polaris-Card__Section--borderTop"
  end

  def test_bottom_border
    render_inline(Polaris::Card::SectionComponent.new(border_bottom: true))

    assert_selector ".Polaris-Card__Section.Polaris-Card__Section--borderBottom"
  end
end
