require "test_helper"

class StackComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_filters
    render_inline(Polaris::FiltersComponent.new) do |filters|
      filters.query(name: :query)
    end

    assert_selector ".Polaris-Filters > .Polaris-Filters-ConnectedFilterControl__Wrapper" do
      # Query
      assert_selector %{
        .Polaris-Filters-ConnectedFilterControl.Polaris-Filters-ConnectedFilterControl--right >
        .Polaris-Filters-ConnectedFilterControl__CenterContainer >
        .Polaris-Filters-ConnectedFilterControl__Item >
        .Polaris-Labelled--hidden
      }.squish do
        assert_selector ".Polaris-Labelled__LabelWrapper label", text: "Query"
        assert_selector ".Polaris-Connected .Polaris-TextField input[name=query]"
      end
    end
  end
end
