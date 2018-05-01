defmodule Clouseau.Colors do
  @moduledoc false

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
                 |> Keyword.merge(Application.get_env(:clouseau, :syntax_colors, []))

  # If the :colors option is set to true use the default colors, merging 
  # any color preferences that may exist in this speciffic call.
  # If the :colors option is set to false don't use the default colors.
  # Any :syntax_colors the user has entered in this call will be used 
  # as they are.
  def apply(options, switches) do
    if Keyword.get(switches, :colors) do
      {_, options_with_colors} =
        Keyword.get_and_update(options, :syntax_colors, fn current_value ->
          {current_value, syntax_colors(current_value)}
        end)

      options_with_colors
    else
      options
    end
  end

  defp syntax_colors(nil) do
    syntax_colors([])
  end

  defp syntax_colors(user_colors) when is_list(user_colors) do
    Keyword.merge(@syntax_colors, user_colors)
  end
end
