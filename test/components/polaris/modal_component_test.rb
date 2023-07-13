require "test_helper"

class ModalComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def test_basic_modal
    render_inline(Polaris::ModalComponent.new(title: "Title")) do |modal|
      modal.with_primary_action { "Primary" }
      modal.with_secondary_action { "Secondary" }

      "Content"
    end

    assert_selector ".Polaris-Modal-Dialog__Container", visible: :all do
      assert_selector ".Polaris-Modal-Dialog > .Polaris-Modal-Dialog__Modal", visible: :all do
        assert_selector "h2", visible: :all, text: "Title"
        assert_selector "button.Polaris-Modal-CloseButton > .Polaris-Icon"

        assert_selector ".Polaris-Modal__Body.Polaris-Scrollable", visible: :all do
          assert_selector ".Polaris-Modal-Section", visible: :all, text: "Content"
        end
        assert_selector ".Polaris-LegacyStack .Polaris-Button--primary", visible: :all, text: "Primary"
        assert_selector ".Polaris-LegacyStack .Polaris-Button", visible: :all, text: "Secondary"
      end
    end
  end

  def test_large_modal
    render_inline(Polaris::ModalComponent.new(title: "Title", large: true)) do |modal|
      "Content"
    end

    assert_selector ".Polaris-Modal-Dialog__Modal.Polaris-Modal-Dialog--sizeLarge", visible: :all
  end

  def test_large_small
    render_inline(Polaris::ModalComponent.new(title: "Title", small: true)) do |modal|
      "Content"
    end

    assert_selector ".Polaris-Modal-Dialog__Modal.Polaris-Modal-Dialog--sizeSmall", visible: :all
  end

  def test_limit_height
    render_inline(Polaris::ModalComponent.new(title: "Title", limit_height: true)) do |modal|
      "Content"
    end

    assert_selector ".Polaris-Modal-Dialog__Modal.Polaris-Modal-Dialog--limitHeight", visible: :all
  end

  def test_custom_close_button
    render_inline(Polaris::ModalComponent.new(title: "Title")) do |modal|
      modal.with_close_button(data: {custom_close: true}) { "Primary" }
      "Content"
    end

    assert_selector "button[data-custom-close]", visible: :all
  end

  def test_multiple_sections
    render_inline(Polaris::ModalComponent.new(title: "Title")) do |modal|
      modal.with_section { "Section1" }
      modal.with_section { "Section2" }
    end

    assert_selector ".Polaris-Modal-Section", visible: :all, count: 2
    assert_selector ".Polaris-Modal-Section:nth-of-type(1)", visible: :all, text: "Section1"
    assert_selector ".Polaris-Modal-Section:nth-of-type(2)", visible: :all, text: "Section2"
  end
end
