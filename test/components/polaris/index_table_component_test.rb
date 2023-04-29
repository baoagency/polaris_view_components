require "test_helper"

class IndexTableComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def setup
    @data = [
      {product: "PRODUCT_NAME", price: "$50"}
    ]
  end

  def test_default_table
    render_inline(Polaris::IndexTableComponent.new(@data)) do |table|
      table.with_column("Product") do |row|
        row[:product]
      end
      table.with_column("Price") do |row|
        row[:price]
      end
    end

    assert_selector ".Polaris-IndexTable > .Polaris-IndexTable-ScrollContainer" do
      assert_selector "table.Polaris-IndexTable__Table" do
        assert_selector "thead" do
          assert_selector "th.Polaris-IndexTable__TableHeading", count: 2
          assert_selector "th.Polaris-IndexTable__TableHeading:nth-child(1)", text: "Product"
          assert_selector "th.Polaris-IndexTable__TableHeading:nth-child(2)", text: "Price"
        end
        assert_selector "tbody" do
          assert_selector "tr.Polaris-IndexTable__TableRow", count: 1
          assert_selector "tr:nth-child(1)" do
            assert_selector "td.Polaris-IndexTable__TableCell", count: 2
            assert_selector "td.Polaris-IndexTable__TableCell:nth-child(1)", text: "PRODUCT_NAME"
            assert_selector "td.Polaris-IndexTable__TableCell:nth-child(2)", text: "$50"
          end
        end
      end
    end
  end
end
