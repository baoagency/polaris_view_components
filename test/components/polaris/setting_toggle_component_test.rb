require "test_helper"

class AvatarComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_enabled_setting_toggle
    render_inline(Polaris::SettingToggleComponent.new(enabled: true)) do |toggle|
      toggle.with_action { "Action" }
      "Content"
    end

    assert_selector ".Polaris-LegacyCard > .Polaris-LegacyCard__Section > .Polaris-SettingAction" do
      assert_selector ".Polaris-SettingAction__Setting", text: "Content"
      assert_selector ".Polaris-SettingAction__Action > .Polaris-Button", text: "Action"
    end
  end

  def test_disabled_setting_toggle
    render_inline(Polaris::SettingToggleComponent.new(enabled: false)) do |toggle|
      toggle.with_action { "Action" }
      "Content"
    end

    assert_selector ".Polaris-SettingAction > .Polaris-SettingAction__Action" do
      assert_selector ".Polaris-Button.Polaris-Button--primary", text: "Action"
    end
  end
end
