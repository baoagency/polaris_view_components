class Rails::FormBuilderComponentPreview < ViewComponent::Preview
  def text_field
    product = Product.new(title: "Product Name")
    render_with_template(locals: {product: product})
  end

  def select
    product = Product.new
    render_with_template(locals: {product: product})
  end

  def check_box
    product = Product.new
    render_with_template(locals: {product: product})
  end

  def radio_button
    product = Product.new
    render_with_template(locals: {product: product})
  end

  def errors
    product = Product.new
    product.errors.add(:title, "can't be blank")
    render_with_template(locals: {product: product})
  end

  def dropzone
    product = Product.new
    render_with_template(locals: {product: product})
  end
end
