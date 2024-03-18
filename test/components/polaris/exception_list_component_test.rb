require "test_helper"

class ExceptionListComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_exception_list
    render_inline(Polaris::ExceptionListComponent.new) do |list|
      list.with_item(icon: "NoteIcon", title: "Title 1") { "Default Note" }
      list.with_item(icon: "NoteIcon", title: "Title 2", status: :warning) { "Warning Note" }
      list.with_item(icon: "NoteIcon", title: "Title 3", status: :critical) { "Critical Note" }
    end

    assert_selector "ul.Polaris-ExceptionList" do
      assert_selector "li.Polaris-ExceptionList__Item", count: 3
      assert_selector "li.Polaris-ExceptionList__Item:nth-child(1)" do
        assert_selector ".Polaris-ExceptionList__Icon > .Polaris-Icon"
        assert_selector ".Polaris-ExceptionList__Title", text: "Title 1"
        assert_selector ".Polaris-ExceptionList__Description", text: "Default Note"
      end
      assert_selector "li.Polaris-ExceptionList__Item.Polaris-ExceptionList--statusWarning:nth-child(2)" do
        assert_selector ".Polaris-ExceptionList__Icon > .Polaris-Icon"
        assert_selector ".Polaris-ExceptionList__Title", text: "Title 2"
        assert_selector ".Polaris-ExceptionList__Description", text: "Warning Note"
      end
      assert_selector "li.Polaris-ExceptionList__Item.Polaris-ExceptionList--statusCritical:nth-child(3)" do
        assert_selector ".Polaris-ExceptionList__Icon > .Polaris-Icon"
        assert_selector ".Polaris-ExceptionList__Title", text: "Title 3"
        assert_selector ".Polaris-ExceptionList__Description", text: "Critical Note"
      end
    end
  end
end
