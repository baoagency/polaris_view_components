require "test_helper"

class SkeletonPageComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_dynamic_page
    render_inline(Polaris::SkeletonPageComponent.new)

    assert_selector ".Polaris-SkeletonPage__Page" do
      assert_selector ".Polaris-SkeletonPage__Header" do
        assert_selector ".Polaris-SkeletonPage__TitleAndPrimaryAction" do
          assert_selector ".Polaris-SkeletonPage__TitleWrapper" do
            assert_selector ".Polaris-SkeletonPage__SkeletonTitle"
          end
        end
      end
      assert_selector ".Polaris-SkeletonPage__Content"
      assert_no_selector ".Polaris-SkeletonPage__PrimaryAction"
    end
  end

  def test_renders_static_page
    render_inline(Polaris::SkeletonPageComponent.new(title: "Test title"))

    assert_selector ".Polaris-SkeletonPage__TitleWrapper" do
      assert_selector "h1.Polaris-SkeletonPage__Title", text: "Test title"
    end
  end

  def test_renders_page_with_primary_action
    render_inline(Polaris::SkeletonPageComponent.new(primary_action: true))

    assert_selector ".Polaris-SkeletonPage__PrimaryAction"
  end
end
