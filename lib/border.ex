defmodule Clouseau.Border do
  @moduledoc false

  @fallback_width 80

  @doc """
  Draws a line of "-" on the screen. The line has a
  width equal to the screen width or 80 chars when
  calculating the screen width is not possible.
  """
  def border do
    border = String.duplicate("-", width())
    red = IO.ANSI.red()
    reset = IO.ANSI.reset()
    IO.iodata_to_binary [red, border, reset]
  end

  defp width do
    case :io.columns do
      {:ok, count} -> count
      _ -> @fallback_width
    end
  end
end
