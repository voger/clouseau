defmodule Clouseau.TemplateEngine do
  use EEx.Engine
  @moduledoc false

  def handle_text(buffer, _text) do
    quote do: unquote(buffer)
  end

  @spec handle_assign(Macro.t()) :: Macro.t()
  def handle_assign({:@, meta, [{name, _, atom}]}) when is_atom(name) and is_atom(atom) do
    line = meta[:line] || 0
    quote line: line, do: Clouseau.TemplateEngine.get_assign(var!(assigns), unquote(name))
  end

  def handle_assign({:has_val?, meta, [{name, _, atom}]}) when is_atom(name) and is_atom(atom) do
    line = meta[:line] || 0
    quote line: line, do: Clouseau.TemplateEngine.assign_valid?(var!(assigns), unquote(name))
  end

  def handle_assign({:from_iolist, _meta, list}) do
    quote do
      IO.ANSI.format_fragment(unquote(list))
    end
  end

  def handle_assign(arg) do
    arg
  end

  def assign_valid?(assigns, key) do
    !(Map.get(assigns, key) in ["", nil, false])
  end

  def get_assign(assigns, key) do
    case Map.get(assigns, key) do
      nil -> ""
      value -> value
    end
  end

  def handle_expr(buffer, "=", expr) do
    expr = Macro.prewalk(expr, &handle_assign/1)

    quote do
      tmp1 = unquote(buffer)
      # When running in iex values like `module` remain nil because 
      # they are not applicable. Discard `nil` values
      if unquote(expr) do
        [tmp1 | unquote(expr)]
      else
        tmp1
      end
    end
  end

  def handle_expr(buffer, "", expr) do
    expr = Macro.prewalk(expr, &handle_assign/1)

    quote do
      tmp1 = unquote(buffer)
      unquote(expr)
      tmp1
    end
  end

  def handle_expr(buffer, marker, expr) do
    expr = Macro.prewalk(expr, &handle_assign/1)
    super(buffer, marker, expr)
  end
end
