defmodule Clouseau.TemplateEngine do
  use EEx.Engine


  def handle_text(buffer, _text) do
    quote do: unquote(buffer)
  end


  @spec handle_assign(Macro.t) :: Macro.t
  def handle_assign({:@, meta, [{name, _, atom}]}) when is_atom(name) and is_atom(atom) do
    line = meta[:line] || 0
    quote line: line, do: Clouseau.TemplateEngine.get_assign(var!(assigns), unquote(name))
  end

  def handle_assign({:has_val?, meta, [{name, _, atom}]}) when is_atom(name) and is_atom(atom) do
    line = meta[:line] || 0
    quote line: line, do: Clouseau.TemplateEngine.assign_valid?(var!(assigns), unquote(name))
  end

  def handle_assign(arg) do
    arg
  end

  def assign_valid?(assigns, key) do
    case  Map.get(assigns, key) do
      val when val in ["", nil, false] -> false
      _ -> true
    end
  end

  def get_assign(assigns, key) do
    Map.get(assigns, key) || ""
  end


  def handle_expr(buffer, mark, expr) do
    expr = Macro.prewalk(expr, &handle_assign/1)
    super(buffer, mark, expr)
  end
end
