require "test_helper"

class PaginationComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_pagination
    render_inline(Polaris::PaginationComponent.new(previous_url: '/previous.html', next_url: '/next.html'))

    assert_selector "nav[aria-label=Pagination] > .Polaris-ButtonGroup.Polaris-ButtonGroup--segmented" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 2
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(1)" do
        assert_selector "a.Polaris-Button.Polaris-Button--outline.Polaris-Button--iconOnly[href='/previous.html']"
        assert_selector ".Polaris-Button__Icon > .Polaris-Icon"
      end
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(2)" do
        assert_selector "a.Polaris-Button.Polaris-Button--outline.Polaris-Button--iconOnly[href='/next.html']"
        assert_selector ".Polaris-Button__Icon > .Polaris-Icon"
      end
    end
  end

  def test_pagination_with_label
    render_inline(Polaris::PaginationComponent.new(previous_url: '/previous.html', label: 'Label'))

    assert_no_selector "nav[aria-label=Pagination] > .Polaris-ButtonGroup--segmented"
    assert_selector "nav[aria-label=Pagination] > .Polaris-ButtonGroup" do
      assert_selector ".Polaris-ButtonGroup__Item", count: 3
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(1)" do
        assert_selector "a.Polaris-Button[href='/previous.html']"
      end
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(2)", text: "Label"
      assert_selector ".Polaris-ButtonGroup__Item:nth-child(3)" do
        assert_selector ".Polaris-Button[disabled=disabled]"
      end
    end
  end
end
