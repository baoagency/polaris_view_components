require "test_helper"

class CollapsibleComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_collapsible
    render_inline(Polaris::CollapsibleComponent.new(expand_on_print: true, open: true)) { "Content" }

    assert_selector ".Polaris-Collapsible.Polaris-Collapsible--expandOnPrint", text: "Content"
    assert_no_selector ".Polaris-Collapsible--isFullyClosed"
  end
end
