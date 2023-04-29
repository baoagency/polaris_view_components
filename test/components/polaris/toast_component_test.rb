require "test_helper"

class ToastComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default_toast
    render_inline(Polaris::ToastComponent.new) { "Content" }

    assert_selector ".Polaris-Frame-ToastManager__ToastWrapper.Polaris-Frame-ToastManager--toastWrapperEnterDone" do
      assert_selector ".Polaris-Frame-Toast" do
        assert_text "Content"
        assert_selector "button.Polaris-Frame-Toast__CloseButton"
      end
    end
  end

  def test_hidden
    render_inline(Polaris::ToastComponent.new(hidden: true)) { "Content" }

    assert_selector ".Polaris-Frame-ToastManager__ToastWrapper"
    assert_no_selector ".Polaris-Frame-ToastManager--toastWrapperEnterDone"
  end

  def test_with_action
    render_inline(Polaris::ToastComponent.new) do |toast|
      toast.with_action { "Action" }
      "Content"
    end

    assert_selector ".Polaris-Frame-Toast" do
      assert_selector ".Polaris-Frame-Toast__Action > button", text: "Action"
    end
  end

  def test_error_toast
    render_inline(Polaris::ToastComponent.new(error: true)) { "Content" }

    assert_selector ".Polaris-Frame-Toast.Polaris-Frame-Toast--error"
  end
end
