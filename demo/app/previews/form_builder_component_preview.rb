class FormBuilderComponentPreview < ViewComponent::Preview
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

  def collection_check_boxes
    product = Product.new(selected_markets: [Market.new(id: 1, name: "US")])
    available_markets = [Market.new(id: 1, name: "US"), Market.new(id: 2, name: "Spain")]
    render_with_template(locals: {product: product, available_markets: available_markets})
  end

  def errors
    product = Product.new
    product.errors.add(:title, "can't be blank")
    render_with_template(locals: {product: product})
  end

  def dropzone
    upload = Upload.new
    render_with_template(locals: {upload: upload})
  end
end
