require "test_helper"

class FiltersComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_filters
    render_inline(Polaris::FiltersComponent.new) do |filters|
      filters.query(name: :query)
      filters.item(label: "Filter") do
        "Content"
      end
    end

    assert_selector ".Polaris-Filters > .Polaris-Filters-ConnectedFilterControl__Wrapper" do
      assert_selector ".Polaris-Filters-ConnectedFilterControl" do
        # Query
        assert_selector ".Polaris-Filters-ConnectedFilterControl__CenterContainer" do
          assert_selector ".Polaris-Filters-ConnectedFilterControl__Item > .Polaris-Labelled--hidden" do
            assert_selector ".Polaris-Labelled__LabelWrapper label", text: "Query"
            assert_selector ".Polaris-Connected .Polaris-TextField input[name=query]"
          end
        end
        # Filter
        assert_selector ".Polaris-Filters-ConnectedFilterControl__RightContainer" do
          assert_selector ".Polaris-Filters-ConnectedFilterControl__Item > [data-controller='polaris-popover']" do
            assert_selector "[data-polaris-popover-target='activator']" do
              assert_selector ".Polaris-Button", text: "Filter"
            end
          end
        end
      end
    end
  end

  def test_custom_content
    render_inline(Polaris::FiltersComponent.new) do |filters|
      "Content"
    end

    assert_selector ".Polaris-Filters-ConnectedFilterControl__Wrapper" do
      assert_selector ".Polaris-Filters-ConnectedFilterControl__AuxiliaryContainer" do
        assert_text "Content"
      end
    end
  end

  def test_disabled
    render_inline(Polaris::FiltersComponent.new(disabled: true)) do |filters|
      filters.query(name: :query)
      filters.item(label: "Filter") do
        "Content"
      end
    end

    assert_selector ".Polaris-Filters-ConnectedFilterControl__CenterContainer" do
      assert_selector "input[disabled]"
    end
    assert_selector ".Polaris-Filters-ConnectedFilterControl__RightContainer" do
      assert_selector "button[disabled]"
    end
  end

  def test_help_text
    render_inline(Polaris::FiltersComponent.new(help_text: "Help Text")) do |filters|
      "Content"
    end

    assert_selector ".Polaris-Filters > .Polaris-Filters__HelpText", text: "Help Text"
  end

  def test_filters_with_tags
    render_inline(Polaris::FiltersComponent.new) do |filters|
      filters.tags do
        "Tags"
      end
      "Content"
    end

    assert_selector ".Polaris-Filters > .Polaris-Filters__TagsContainer", text: "Tags"
  end
end
