require "test_helper"

class DisplayTextComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_default
    render_inline(Polaris::ProgressBarComponent.new(progress: 75))

    assert_selector ".Polaris-ProgressBar .Polaris-ProgressBar__Label", text: "75%"
  end

  def test_size_option
    render_inline(Polaris::ProgressBarComponent.new(progress: 40, size: :small))

    assert_selector ".Polaris-ProgressBar--sizeSmall", count: 1

    render_inline(Polaris::ProgressBarComponent.new(progress: 40, size: :large))

    assert_selector ".Polaris-ProgressBar--sizeLarge", count: 1
  end

  def test_color_option
    render_inline(Polaris::ProgressBarComponent.new(progress: 70, color: :primary))

    assert_selector ".Polaris-ProgressBar--colorPrimary", count: 1

    render_inline(Polaris::ProgressBarComponent.new(progress: 30, color: :success))

    assert_selector ".Polaris-ProgressBar--colorSuccess", count: 1
  end
end
