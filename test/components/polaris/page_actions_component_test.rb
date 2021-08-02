require "test_helper"

class PageActionsComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_page_actions
    render_inline(Polaris::PageActionsComponent.new) do |actions|
      actions.primary_action(url: "/save") { "Primary Button" }
      actions.secondary_action(url: "/destroy", destructive: true) { "Delete Button" }
      actions.secondary_action { "Default Button" }
    end

    assert_selector ".Polaris-PageActions" do
      assert_selector ".Polaris-Stack.Polaris-Stack--distributionEqualSpacing.Polaris-Stack--spacingTight" do
        assert_selector ".Polaris-Stack__Item", count: 2
        assert_selector ".Polaris-Stack__Item:nth-child(1)" do
          assert_selector ".Polaris-ButtonGroup" do
            assert_selector ".Polaris-ButtonGroup__Item", count: 2
            assert_selector ".Polaris-ButtonGroup__Item:nth-child(1)" do
              assert_selector "a.Polaris-Button--destructive[href='/destroy']", text: "Delete Button"
            end
            assert_selector ".Polaris-ButtonGroup__Item:nth-child(2)" do
              assert_selector "button.Polaris-Button", text: "Default Button"
            end
          end
        end
        assert_selector ".Polaris-Stack__Item:nth-child(2)" do
          assert_selector "a.Polaris-Button--primary[href='/save']", text: "Primary Button"
        end
      end
    end
  end

  def test_renders_only_primary_action
    render_inline(Polaris::PageActionsComponent.new) do |actions|
      actions.primary_action(url: "/save") { "Save Button" }
    end

    assert_selector ".Polaris-PageActions > .Polaris-Stack--distributionTrailing"
  end
end
