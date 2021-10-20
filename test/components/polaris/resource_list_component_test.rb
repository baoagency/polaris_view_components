require "test_helper"

class ResourceListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_resource_list
    render_inline(Polaris::ResourceListComponent.new) do
      "Content"
    end

    assert_selector ".Polaris-ResourceList__ResourceListWrapper" do
      assert_selector "ul.Polaris-ResourceList"
    end
  end

  def test_resource_list_with_filters
    render_inline(Polaris::ResourceListComponent.new) do |resource_list|
      resource_list.filters do |filters|
        filters.query(name: :query)
      end
      "Content"
    end

    assert_selector ".Polaris-ResourceList__ResourceListWrapper" do
      assert_selector ".Polaris-ResourceList__FiltersWrapper > .Polaris-Filters"
    end
  end
end
