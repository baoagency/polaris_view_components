class Polaris::TextField::ComponentPreview < ViewComponent::Preview
  def default
    model = Model.new(attribute: 'Value')
    render_with_template(locals: { model: model })
  end

  def number
    render_with_template(locals: { model: Model.new })
  end

  def email
    render_with_template(locals: { model: Model.new })
  end

  def multiline
    render_with_template(locals: { model: Model.new })
  end

  def with_hidden_label
    render_with_template(locals: { model: Model.new })
  end

  def with_label_action
    render_with_template(locals: { model: Model.new })
  end

  def with_right_aligned_text
    render_with_template(locals: { model: Model.new })
  end

  def with_placeholder_text
    render_with_template(locals: { model: Model.new })
  end

  def with_help_text
    render_with_template(locals: { model: Model.new })
  end

  def with_prefix_or_suffix
    render_with_template(locals: { model: Model.new })
  end

  def with_connected_fields
    render_with_template(locals: { model: Model.new })
  end

  def with_validation_error
    render_with_template(locals: { model: Model.new })
  end

  def with_separate_validation_error
    render_with_template(locals: { model: Model.new })
  end

  def disabled
    render_with_template(locals: { model: Model.new })
  end

  def with_character_count
    render_with_template(locals: { model: Model.new })
  end

  def with_clear_button
    render_with_template(locals: { model: Model.new })
  end

  def with_monospaced_font
    render_with_template(locals: { model: Model.new })
  end
end
