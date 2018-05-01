# credo:disable-for-file Clouseau.Check.Warning.ClInspect
defmodule Cl do
  @moduledoc """
  This is the main module to use. You need to first require it in your file

  `require Cl`

  and then use `Cl.inspect/2` or `Cl.inspect/3` where you would normaly use `IO.inspect`
  """

  @doc """
  Use it like the `IO.inspect/3` function
  """
  defmacro inspect(device, item, opts) when is_list(opts) do
    quote bind_quoted: [device: device, item: item, opts: opts], unquote: true do
      {label, opts_without_label} = Keyword.pop(opts, :label, "")
      {switches, text} = Clouseau.Switches.parse(label)
      rendered_label = Clouseau.Label.render(text, switches, __ENV__)

      opts_with_color = Clouseau.Colors.apply(opts_without_label, switches)

      IO.write(device, rendered_label)
      # credo:disable-for-next-line Credo.Check.Warning.IoInspect
      IO.inspect(device, item, opts_with_color)

      if Keyword.fetch!(switches, :border) do
        border = Clouseau.Border.border()
        IO.puts(device, border)
      end

      item
    end
  end

  @doc """
  Use it like the `IO.inspect/2` function
  """
  defmacro inspect(item, opts \\ []) do
    # credo:disable-for-next-line Clouseau.Check.Warning.ClInspect
    quote do: Cl.inspect(unquote(:stdio), unquote(item), unquote(opts))
  end
end
