require "test_helper"

class Polaris::ViewHelperTest < ActionView::TestCase
  include Polaris::ComponentTestHelpers

  class Product
    include ActiveModel::Model
    attr_accessor :title, :status, :accept, :access, :selected_markets, :tags

    validates :title, presence: true
  end

  setup do
    @product = Product.new
    @available_markets = [Market.new(id: 1, name: "US"), Market.new(id: 2, name: "Spain")]
    @builder = Polaris::FormBuilder.new(:product, @product, self, {})
  end

  test "#errors_summary" do
    @product.validate
    @product.errors.add(:base, "Base Error")

    @rendered_content = @builder.errors_summary

    assert_selector ".Polaris-Banner--statusCritical" do
      assert_text "2 errors with this product"
      assert_selector "li", text: "Base Error"
      assert_selector "li", text: "Title can't be blank"
    end
  end

  test "#error_for" do
    @product.errors.add(:title, "Error")

    assert_equal "Title Error", @builder.error_for(:title)
  end

  test "#polaris_inline_error_for" do
    @product.errors.add(:title, "Error")

    @rendered_content = @builder.polaris_inline_error_for(:title)

    assert_selector ".Polaris-InlineError" do
      assert_selector ".Polaris-InlineError__Icon"
      assert_text "Title Error"
    end
  end

  test "#polaris_text_field" do
    @rendered_content = @builder.polaris_text_field(:title, help_text: "Help Text")

    assert_selector ".Polaris-Label" do
      assert_selector "label", text: "Title"
    end
    assert_selector ".Polaris-TextField" do
      assert_selector %(input[name="product[title]"])
      assert_selector ".Polaris-Labelled__HelpText", text: "Help Text"
    end
  end

  test "#polaris_select" do
    @rendered_content = @builder.polaris_select(:status, options: {"Active" => "active", "Draft" => "draft"})

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
    @rendered_content = @builder.polaris_check_box(:accept, label: "Checkbox Label")

    assert_selector "label.Polaris-Choice" do
      assert_selector ".Polaris-Choice__Label", text: "Checkbox Label"
      assert_selector ".Polaris-Checkbox" do
        assert_selector %(input[name="product[accept]"][type="checkbox"])
      end
    end
  end

  test "#polaris_check_box checked" do
    @rendered_content = @builder.polaris_check_box(:accept, label: "Checkbox Label", checked: true)

    assert_selector ".Polaris-Checkbox" do
      assert_selector %(input[name="product[accept]"][type="checkbox"][checked="checked"])
    end
  end

  test "#polaris_radio_button" do
    @rendered_content = @builder.polaris_radio_button(:access, value: :allow, label: "Radio Label")

    assert_selector "label.Polaris-Choice" do
      assert_selector ".Polaris-Choice__Label", text: "Radio Label"
      assert_selector ".Polaris-RadioButton" do
        assert_selector %(input[name="product[access]"][value="allow"][type="radio"])
      end
    end
  end

  test "#polaris_radio_button checked" do
    @product = Product.new(access: :allow)
    @builder = Polaris::FormBuilder.new(:product, @product, self, {})
    @rendered_content = @builder.polaris_radio_button(:access, value: :allow, label: "Radio Label")

    assert_selector "label.Polaris-Choice" do
      assert_selector ".Polaris-Choice__Label", text: "Radio Label"
      assert_selector ".Polaris-RadioButton" do
        assert_selector %(input[name="product[access]"][value="allow"][type="radio"][checked="checked"])
      end
    end
  end

  test "#polaris_radio_button checked manually" do
    @rendered_content = @builder.polaris_radio_button(:access, value: :allow, checked: true, label: "Radio Label")

    assert_selector "label.Polaris-Choice" do
      assert_selector ".Polaris-Choice__Label", text: "Radio Label"
      assert_selector ".Polaris-RadioButton" do
        assert_selector %(input[name="product[access]"][value="allow"][type="radio"][checked="checked"])
      end
    end
  end

  test "#polaris_dropzone" do
    @rendered_content = @builder.polaris_dropzone(:image, label: "Dropzone Label")

    assert_selector ".Polaris-Label" do
      assert_selector "label", text: "Dropzone Label"
    end
    assert_selector ".Polaris-DropZone" do
      assert_selector %(input[type=file][name="product[image][]"])
    end
  end

  test "#polaris_collection_check_boxes" do
    @rendered_content = @builder.polaris_collection_check_boxes(:selected_markets, @available_markets, :id, :name)

    assert_selector "legend", text: "Selected markets"
    assert_selector "ul" do
      assert_selector "li", count: 2
      assert_selector "li:nth-child(1)" do
        assert_selector "input[type=checkbox][name='product[selected_markets][]'][value=1]"
        assert_text "US"
      end
      assert_selector "li:nth-child(2)" do
        assert_selector "input[type=checkbox][name='product[selected_markets][]'][value=2]"
        assert_text "Spain"
      end
    end
  end

  test "#polaris_collection_check_boxes with selected_markets" do
    @product.selected_markets = [Market.new(id: 1, name: "US")]
    @rendered_content = @builder.polaris_collection_check_boxes(:selected_markets, @available_markets, :id, :name)

    assert_selector "legend", text: "Selected markets"
    assert_selector "ul" do
      assert_selector "li", count: 2
      assert_selector "li:nth-child(1)" do
        assert_selector "input[type=checkbox][name='product[selected_markets][]'][value=1][checked='checked']"
        assert_text "US"
      end
      assert_selector "li:nth-child(2)" do
        assert_selector "input[type=checkbox][name='product[selected_markets][]'][value=2]"
        assert_no_selector "input[type=checkbox][name='product[selected_markets][]'][value=2][checked='checked']"
        assert_text "Spain"
      end
    end
  end

  test "#polaris_autocomplete" do
    @rendered_content = @builder.polaris_autocomplete(:tags) do |autocomplete|
      autocomplete.with_text_field(label: "Tags", placeholder: "Search")

      autocomplete.with_option(label: "Rustic", value: "rustic")
      autocomplete.with_option(label: "Antique", value: "antique")
      autocomplete.with_option(label: "Vinyl", value: "vinyl")
      autocomplete.with_option(label: "Vintage", value: "vintage")
      autocomplete.with_option(label: "Refurbished", value: "refurbished")
    end

    assert_selector ".Polaris-Label" do
      assert_selector "label", text: "Tags"
    end
    assert_selector ".Polaris-TextField" do
      assert_selector %(input[name="product[tags]"])
    end
  end
end
