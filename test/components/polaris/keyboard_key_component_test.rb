require "test_helper"

class KeyboardKeyComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_keyboard_key
    render_inline(Polaris::KeyboardKeyComponent.new) { "ctrl" }

    assert_selector ".Polaris-KeyboardKey", text: "ctrl"
  end
end
