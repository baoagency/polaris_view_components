require "test_helper"

class DescriptionListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_description_list
    render_inline(Polaris::DescriptionListComponent.new) do |list|
      list.with_item(term: "Term 1") { "Description 1" }
      list.with_item(term: "Term 2") { "Description 2" }
    end

    assert_selector "dl.Polaris-DescriptionList" do
      assert_selector "dt.Polaris-DescriptionList__Term", count: 2
      assert_selector "dd.Polaris-DescriptionList__Description", count: 2

      assert_selector "dt.Polaris-DescriptionList__Term:nth-child(1)", text: "Term 1"
      assert_selector "dd.Polaris-DescriptionList__Description:nth-child(2)", text: "Description 1"

      assert_selector "dt.Polaris-DescriptionList__Term:nth-child(3)", text: "Term 2"
      assert_selector "dd.Polaris-DescriptionList__Description:nth-child(4)", text: "Description 2"
    end
  end

  def test_tight_spacing_description_list
    render_inline(Polaris::DescriptionListComponent.new(spacing: :tight)) do |list|
      list.with_item(term: "Term 1") { "Description 1" }
      list.with_item(term: "Term 2") { "Description 2" }
    end

    assert_selector "dl.Polaris-DescriptionList--spacingTight"
  end
end
