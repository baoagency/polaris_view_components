require "test_helper"

class EmptySearchResultsComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_empty_search_results
    render_inline(Polaris::EmptySearchResultsComponent.new(
      title: "TITLE",
      description: "DESCRIPTION"
    ))

    assert_selector ".Polaris-EmptySearchResults > .Polaris-EmptySearchResults__Content" do
      assert_selector ".Polaris-DisplayText--sizeSmall", text: "TITLE"
      assert_selector ".Polaris-TextStyle--variationSubdued", text: "DESCRIPTION"
    end
  end
end
