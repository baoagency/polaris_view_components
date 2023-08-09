module RenderWithLocals
  def render_with_locals(bind)
    caller_method_name = caller_locations(1, 1)[0].label
    parameter_names = method(caller_method_name).parameters.map(&:last)
    locals = parameter_names.index_with { |name| bind.local_variable_get(name) }
    render_with_template(locals: locals)
  end
end

ViewComponent::Preview.include(RenderWithLocals)
