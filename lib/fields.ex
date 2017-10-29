defmodule Clouseau.Fields do
  alias Clouseau.Fields
  import Keyword, only: [get: 2]


  @moduledoc """
  This is the struct that holds the fields for the label
  Use new/3 to initialize the struct.
  The fields are initalized according to the switches. Disabled fields are set to `nil`
  """


  @enforced_keys ~W(file module line text)a

  defstruct @enforced_keys

  @doc """
  Creates a new struct and initializes it according to the switches
  caller is a `__ENV__` struct that holds the caller's info
  text is the text that will label the term
  switches is a keyword list with the boolean switches. See Clouseau.Switches for details
  """
  def new(caller, text, switches) do
    %Fields{
      file:   assign_file(caller, get(switches, :file), get(switches, :full_path)),
      module: assign_module(caller, get(switches, :module)),
      line:   assign_line(caller, get(switches, :line)),
      text:   assign_text(text, get(switches, :text))
    }
  end

  defp assign_module(_, false), do: disable()
  defp assign_module(caller, true) do
      caller.module
      |> to_string()
      |> String.replace(~r/^Elixir\./, "")
  end

  defp assign_file(_, false, _), do: disable()

  defp assign_file(caller, true, true), do:  caller.file

  defp assign_file(caller, true, false) do
    file = caller.file
    case File.cwd() do
      {:ok, dir} ->
        Path.relative_to(file, dir)
      {:error, _} ->
        file
    end
  end

  defp assign_line(_caller, false), do: disable()
  defp assign_line(caller, true), do: to_string(caller.line)

  defp assign_text(text, _) when text in ["", nil], do: disable()
  defp assign_text(_, false), do: disable()
  defp assign_text(text, true), do: text

  defp disable, do: nil

end
