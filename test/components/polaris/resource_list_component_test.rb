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
end
