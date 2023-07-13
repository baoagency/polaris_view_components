require "test_helper"

class VisuallyHiddenComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders
    render_inline(Polaris::VisuallyHiddenComponent.new) { "Hidden Text" }

    assert_selector "span.Polaris-Text--visuallyHidden", text: "Hidden Text"
  end
end
