defmodule Clouseau.Colors do
  @syntax_colors [
    atom: :cyan,
    string: :green,
    list: :default_color,
    boolean: :magenta,
    nil: :magenta,
    tuple: :default_color,
    binary: :default_color,
    number: :yellow,
    map: :default_color
  ]

  def syntax_colors(nil) do
    syntax_colors([])
  end

  def syntax_colors(syntax_colors) when is_list(syntax_colors) do
    @syntax_colors
    |> Keyword.merge(Application.get_env(:clouseau, :syntax_colors, []))
    |> Keyword.merge(syntax_colors)
  end
end
