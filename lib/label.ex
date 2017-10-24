defmodule Clouseau.Label do
  alias Clouseau.Switches
  alias Clouseau.Fields
  alias Clouseau.Render

  @moduledoc """
  Renders a label according to the switches.
  """

  @regex  ~R/
          (?:(?<=\s)|^)         # It has a space in the front or begins at the start of the line
          -{1,2}                # It starts with one or two dashes
          \w+                   # followed by at least one alphanumeric
          (?:\w|(?<!-)-)*       # Followed by one or more alphanumerics or dashes.
                                # Rejects two dashes together
          /x


  defp parse(nil), do: parse("")

  defp parse(label) do
    {given_switches, string_list, _} =
      label
      |> switches(@regex)
      |> OptionParser.parse(strict: Switches.valid_switches(), aliases: Switches.aliases())
    text = text(label, @regex)
    {Switches.apply(given_switches), text}
  end

  def regex, do: @regex

  # Returns a list with everything that looks like a switch.
  # Switches that are not meant to be used should be escaped
  # with two backslashes "\\"
  defp switches(string, regex) do
    regex
    |> Regex.scan(string)
    |> List.flatten()
  end

  # Removes everything that looks like a switch.
  # Switches that are not meant to be removed should be
  # escaped with "\\"
  defp text(string, regex) do
    string
    |> String.replace(regex, "")
    |> String.replace("\\-", "-")
    |> String.trim()
  end


  # Takes a string containing text and the appropriate switches and
  # renders is according to the given switches by using a template.

  # string is a string with the format "-<switches> <The actual text>"
  # caller is a `__ENV__` struct

  # If you want to add switches to your text, e.g.: "Using with the -d switch",
  # then escape it with \. "Using with the \-d switch"

  # Returns a tuple {switches, label} where:
  #   switches is a keyword list with the switches used to render the template
  #   label is the rendered template
  def render(string, caller) do
    {switches, text} = parse(string)
    fields = Fields.new(caller, text, switches)
    {switches, Render.label(fields)}
  end
end
