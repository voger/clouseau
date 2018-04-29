defmodule Clouseau.Colors do
  @syntax_colors [
    atom: :cyan,
    string: :green,
    list: :default_color,
    boolean: :magenta,
    nil: :magenta,
    tuple: :default_color,
    binary: :default_color,
    map: :default_color
  ]

  def syntax_colors, do: @syntax_colors
end
