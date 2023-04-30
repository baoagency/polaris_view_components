require "test_helper"

class SkeletonPageComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_static_page
    render_inline(Polaris::SkeletonPageComponent.new(title: "Test title"))

    assert_selector "h1", text: "Test title"
  end
end
