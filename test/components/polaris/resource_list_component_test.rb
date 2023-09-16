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
      resource_list.with_filters do |filters|
        filters.with_query(name: :query)
      end
      "Content"
    end

    assert_selector ".Polaris-ResourceList__ResourceListWrapper" do
      assert_selector ".Polaris-ResourceList__FiltersWrapper > .Polaris-LegacyFilters"
    end
  end

  def test_resource_list_with_total_items_count
    items = [
      {
        url: "customers/341",
        name: "Mae Jemison",
        location: "Decatur, USA"
      },
      {
        url: "customers/256",
        name: "Ellen Ochoa",
        location: "Los Angeles, USA"
      }
    ]

    render_inline(Polaris::ResourceListComponent.new(
      resource_name: {
        singular: "customer",
        plural: "customers"
      },
      items: items,
      total_items_count: 50
    )) do |resource_list|
      "Content"
    end

    assert_selector ".Polaris-ResourceList__ResourceListWrapper" do
      assert_selector ".Polaris-ResourceList__HeaderWrapper"
    end
  end
end
