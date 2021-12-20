require "test_helper"

class Polaris::ViewHelperTest < ActionView::TestCase
  include Polaris::ComponentTestHelpers

  class Product
    include ActiveModel::Model
    attr_accessor :title, :status, :accept, :access

    validates :title, presence: true
  end

  setup do
    @product = Product.new
    @builder = Polaris::FormBuilder.new(:product, @product, self, {})
  end

  test "#errors_summary" do
    @product.validate
    @product.errors.add(:base, "Base Error")

    @rendered_component = @builder.errors_summary

    assert_selector ".Polaris-Banner--statusCritical" do
      assert_text "2 errors with this product"
      assert_selector ".Polaris-Banner__Content" do
        assert_selector "li", text: "Base Error"
        assert_selector "li", text: "Title can't be blank"
      end
    end
  end

  test "#error_for" do
    @product.errors.add(:title, "Error")

    assert_equal "Title Error", @builder.error_for(:title)
  end

  test "#polaris_inline_error_for" do
    @product.errors.add(:title, "Error")

    @rendered_component = @builder.polaris_inline_error_for(:title)

    assert_selector ".Polaris-InlineError" do
      assert_selector ".Polaris-InlineError__Icon"
      assert_text "Title Error"
    end
  end

  test "#polaris_text_field" do
    @rendered_component = @builder.polaris_text_field(:title, help_text: "Help Text")

    assert_selector ".Polaris-Label" do
      assert_selector "label", text: "Title"
    end
    assert_selector ".Polaris-TextField" do
      assert_selector %(input[name="product[title]"])
      assert_selector ".Polaris-Labelled__HelpText", text: "Help Text"
    end
  end

  test "#polaris_select" do
    @rendered_component = @builder.polaris_select(:status, options: {"Active" => "active", "Draft" => "draft"})

    assert_selector ".Polaris-Label" do
      assert_selector "label", text: "Status"
    end
    assert_selector ".Polaris-Select" do
      assert_selector %(select[name="product[status]"])
      assert_selector "option[value=active]"
      assert_selector "option[value=draft]"
    end
  end

  test "#polaris_check_box" do
    @rendered_component = @builder.polaris_check_box(:accept, label: "Checkbox Label")

    assert_selector "label.Polaris-Choice" do
      assert_selector ".Polaris-Choice__Label", text: "Checkbox Label"
      assert_selector ".Polaris-Checkbox" do
        assert_selector %(input[name="product[accept]"][type="checkbox"])
      end
    end
  end

  test "#polaris_radio_button" do
    @rendered_component = @builder.polaris_radio_button(:access, value: :allow, label: "Radio Label")

    assert_selector "label.Polaris-Choice" do
      assert_selector ".Polaris-Choice__Label", text: "Radio Label"
      assert_selector ".Polaris-RadioButton" do
        assert_selector %(input[name="product[access]"][value="allow"][type="radio"])
      end
    end
  end
end
