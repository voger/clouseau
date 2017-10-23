defmodule Clouseau.Label do
  alias Clouseau.Switches
  alias Clouseau.Fields
  alias Clouseau.Render

  @moduledoc """
  Renders a label according to the switches.
  """

  defp parse(nil), do: parse("")

  defp parse(label) do
    {given_switches, string_list, _} =
      label
      |> OptionParser.split()
      |> OptionParser.parse(strict: Switches.valid_switches(), aliases: Switches.aliases())
    text = Enum.join string_list, " "
    {Switches.apply(given_switches), text}
  end


  @doc """
  Takes a string containing text and the appropriate switches and
  renders is according to the given switches by using a template.

  string is a string with the format "-<switches> <The actual text>"
  caller is a `__ENV__` struct

  Returns a tuple {switches, label} where:
    switches is a keyword list with the switches used to render the template
    label is the rendered template
  """
  def render(string, caller) do
    {switches, text} = parse(string)
    fields = Fields.new(caller, text, switches)
    {switches, Render.label(fields)}
  end
end
