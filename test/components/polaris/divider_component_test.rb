require "test_helper"

class DividerComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default
    render_inline(Polaris::DividerComponent.new)

    assert_selector "hr.Polaris-Divider"
  end
end
