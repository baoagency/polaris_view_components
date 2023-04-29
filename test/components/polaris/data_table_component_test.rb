require "test_helper"

class DataTableComponentTest < Minitest::Test
  include Polaris::ComponentTestHelpers

  def setup
    @data = [
      {product: "PRODUCT_NAME", price: "$50"}
    ]
  end

  def test_default_table
    render_inline(Polaris::DataTableComponent.new(@data)) do |table|
      table.with_column("Product") do |row|
        row[:product]
      end
      table.with_column("Price", numeric: true) do |row|
        row[:price]
      end
    end

    assert_selector ".Polaris-DataTable > .Polaris-DataTable__ScrollContainer > table.Polaris-DataTable__Table" do
      assert_selector "thead th.Polaris-DataTable__Cell", count: 2
      assert_selector "thead th.Polaris-DataTable__Cell--firstColumn.Polaris-DataTable__Cell--header:nth-child(1)" do
        assert_text "Product"
      end
      assert_selector "thead th.Polaris-DataTable__Cell--header:nth-child(2)" do
        assert_text "Price"
      end
      assert_selector "tbody .Polaris-DataTable__Cell", count: 2
      assert_selector "tbody tr:nth-child(1)" do
        assert_selector "th.Polaris-DataTable__Cell--firstColumn", text: "PRODUCT_NAME"
        assert_selector "td.Polaris-DataTable__Cell--numeric", text: "$50"
      end
    end
  end

  def test_totals_in_header
    render_inline(Polaris::DataTableComponent.new(@data, totals_in_header: true)) do |table|
      table.with_column("Product", total: "Totals") do |row|
        row[:product]
      end
      table.with_column("Price", total: "$100") do |row|
        row[:price]
      end
    end

    assert_selector "thead > tr:nth-child(2)" do
      assert_selector "th.Polaris-DataTable__Cell--total:nth-child(1)", text: "Totals"
      assert_selector "td.Polaris-DataTable__Cell--total:nth-child(2)", text: "$100"
    end
  end

  def test_totals_in_footer
    render_inline(Polaris::DataTableComponent.new(@data, totals_in_footer: true)) do |table|
      table.with_column("Product", total: "Totals") do |row|
        row[:product]
      end
      table.with_column("Price", total: "$100") do |row|
        row[:price]
      end
    end

    assert_selector "tfoot > tr" do
      assert_selector "th.Polaris-DataTable__Cell--total:nth-child(1)", text: "Totals"
      assert_selector "td.Polaris-DataTable__Cell--total:nth-child(2)", text: "$100"
    end
  end

  def test_custom_footer
    render_inline(Polaris::DataTableComponent.new(@data)) do |table|
      table.with_column("Product") do |row|
        row[:product]
      end
      table.with_column("Price", numeric: true) do |row|
        row[:price]
      end
      table.with_footer do
        tag.p "Custom content"
      end
    end

    assert_selector ".Polaris-DataTable > .Polaris-DataTable__Footer", text: "Custom content"
  end

  def test_sort
    render_inline(Polaris::DataTableComponent.new(@data)) do |table|
      table.with_column("Product", sort_url: "/sort1") do |row|
        row[:product]
      end
      table.with_column("Price", sort_url: "/sort2", sorted: :asc) do |row|
        row[:price]
      end
    end

    assert_selector "thead th.Polaris-DataTable__Cell--sortable:nth-child(1)" do
      assert_text "Product"
    end
    assert_selector "thead th.Polaris-DataTable__Cell--sorted:nth-child(2)" do
      assert_selector "a.Polaris-DataTable__Heading > .Polaris-DataTable__Icon > .Polaris-Icon"
      assert_text "Price"
    end
  end
end
