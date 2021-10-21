require "test_helper"

class Polaris::ViewHelperTest < ActionView::TestCase
  test "text style shortcut" do
    assert_dom_equal(
      %(<span class="Polaris-TextStyle--variationSubdued">No supplier listed</span>),
      polaris_text_subdued { "No supplier listed" }
    )
  end
end
