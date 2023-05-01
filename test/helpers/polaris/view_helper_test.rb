require "test_helper"

class Polaris::ViewHelperTest < ActionView::TestCase
  test "text style shortcut" do
    content = polaris_text_subdued { "No supplier listed" }

    assert_match(/Polaris-Text--subdued/, content)
    assert_match(/No supplier listed/, content)
  end
end
