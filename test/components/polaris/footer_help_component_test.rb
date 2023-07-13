require "test_helper"

class FooterHelpComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders
    render_inline(Polaris::FooterHelpComponent.new) { "Help Content" }

    assert_selector ".Polaris-FooterHelp" do
      assert_selector ".Polaris-FooterHelp__Text", text: "Help Content"
    end
  end
end
