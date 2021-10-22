class Rails::FormBuilderComponentPreview < ViewComponent::Preview
  def text_field
    product = Product.new(title: "Product Name")
    render_with_template(locals: { product: product })
  end

  def select
    product = Product.new
    render_with_template(locals: { product: product })
  end
end
