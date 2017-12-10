defmodule Clouseau.Label do
  alias Clouseau.Switches
  alias Clouseau.Fields
  alias Clouseau.Render

  @moduledoc """
  Renders a label according to the switches.
  """

  @regex  ~R/
          ^                     # Position at the begginning of the string
          -{1,2}                # It starts with one or two dashes
          \w+                   # followed by at least one alphanumeric
          (?:\w|(?<!-)-)*       # Followed by one or more alphanumerics or dashes. Rejects two dashes together
          /x


  defp parse(nil), do: parse("")

  defp parse(label) do
    {given_switches, [text], _} =
      label
      |> to_arguments()
      |> OptionParser.parse(strict: Switches.valid_switches(),
                            aliases: Switches.aliases())
    {Switches.apply(given_switches), text}
  end

  # Converts a string to arguments list to prepare it for
  # `OptionParser.parse/2`. It returns a list containing
  # switches, aliases, groups of aliases and the remaining string.
  #
  # Active options are considered all options in the beginning of the string,
  # up to the first word that doesn't match the @regex.
  #
  # Example:
  #  `" -bm --no-file Trying with the -b option"`
  #  returns
  #  `["Trying with the -b option", "--no-file", "-bm"]`
  #
  # If the remaining string contains leading white spaces, the first
  # is always removed. The subsequent whitespaces remain. This convention
  # is used in order to keep the output it as consistent as posible with
  # `IO.inspect` who desn't trim any white space.
  defp to_arguments(label, argv \\ []) when is_binary(label) do
    case Regex.run(@regex, trimed = String.trim_leading(label)) do
      nil ->
        # We don't have a switch. Stop looking for more switches.
        # Remove any first whitespace from the remaining string
        # and return the results
        [String.replace(label, ~R/^\h/, "")] ++ argv
      [switch] = result ->
        # We have a switch. Remove it from the string
        # and prepend it to argv. Look for the next switch
        trimed
        |> String.trim_leading(switch)
        |> to_arguments(result ++ argv)
    end
  end



  # Takes a string containing text and the appropriate switches and
  # renders is according to the given switches by using a template.
  #
  # string is the label coming from the user
  # caller is a `__ENV__` struct
  #
  # Returns a tuple {switches, label} where:
  #   switches is a keyword list with the switches used to render the template
  #   label is the rendered template
  def render(string, caller) do
    {switches, text} = parse(string)
    fields = Fields.new(caller, text, switches)
    {switches, Render.label(fields)}
  end
end
