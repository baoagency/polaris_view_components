require "test_helper"

class SpinnerComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_renders_default_spinner
    render_inline(Polaris::SpinnerComponent.new)

    assert_selector "span.Polaris-Spinner.Polaris-Spinner--sizeLarge > svg"
  end

  def test_renders_small_spinner
    render_inline(Polaris::SpinnerComponent.new(size: :small))

    assert_selector "span.Polaris-Spinner.Polaris-Spinner--sizeSmall > svg"
  end
end
