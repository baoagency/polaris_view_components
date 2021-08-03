require "test_helper"

class InlineErrorComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_inline_error
    render_inline(Polaris::InlineErrorComponent.new) { "Error Text" }

    assert_selector ".Polaris-InlineError" do
      assert_selector ".Polaris-InlineError__Icon > .Polaris-Icon"
      assert_text "Error Text"
    end
  end
end
