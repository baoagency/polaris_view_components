require "test_helper"

class CollapsibleComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_collapsible
    render_inline(Polaris::CollapsibleComponent.new(expand_on_print: true, open: true)) { "Content" }

    assert_selector ".Polaris-Collapsible.Polaris-Collapsible--expandOnPrint", text: "Content"
    assert_no_selector ".Polaris-Collapsible--isFullyClosed"
    assert_no_selector ".Polaris-Collapsible__Trigger"
  end

  def test_title
    render_inline(Polaris::CollapsibleComponent.new(title: "Advanced", id: "advanced")) { "Content" }

    assert_selector "div > button.Polaris-Button.Polaris-Button--plain.Polaris-Collapsible__Trigger[aria-controls='advanced'][aria-expanded='false']", text: "Advanced" do
      assert_selector ".Polaris-Button__Icon .Polaris-Icon"
    end
    assert_selector "button[data-controller~='polaris'][data-target='#advanced'][data-action='polaris#toggleCollapsible']"
    assert_selector "button + .Polaris-Collapsible.Polaris-Collapsible--isFullyClosed#advanced", visible: :all
  end

  def test_title_open
    render_inline(Polaris::CollapsibleComponent.new(title: "Advanced", open: true)) { "Content" }

    assert_selector ".Polaris-Collapsible__Trigger[aria-expanded='true']"
    assert_selector ".Polaris-Collapsible", text: "Content"
  end

  def test_title_generates_id
    render_inline(Polaris::CollapsibleComponent.new(title: "Advanced")) { "Content" }

    id = page.find(".Polaris-Collapsible", visible: :all)[:id]
    assert_match(/\Apolaris-collapsible-\h{8}\z/, id)
    assert_selector ".Polaris-Collapsible__Trigger[aria-controls='#{id}']"
  end
end
