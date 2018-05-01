defmodule Clouseau.Switches do
  @moduledoc false

  @valid_switches [
    file: :boolean,
    full_path: :boolean,
    module: :boolean,
    line: :boolean,
    text: :boolean,
    border: :boolean,
    colors: :boolean
  ]

  @aliases [
    f: :file,
    m: :module,
    l: :line,
    t: :text,
    b: :border,
    c: :colors
  ]

  @predefined_switches [
    file: true,
    full_path: false,
    module: true,
    line: true,
    text: true,
    border: false,
    colors: false
  ]

  @no_switches Enum.map(@predefined_switches, fn {key, _} -> {key, false} end)

  @default_switches Keyword.merge(
                      @no_switches,
                      Application.get_env(:clouseau, :default_switches, @predefined_switches)
                    )

  @regex ~R/
          ^                     # Position at the begginning of the string
          -{1,2}                # It starts with one or two dashes
          \w+                   # followed by at least one alphanumeric
          (?:\w|(?<!-)-)*       # Followed by one or more alphanumerics or dashes. Rejects two dashes together
          /x

  defp apply(switches) do
    Keyword.merge(@default_switches, switches)
  end

  def parse(label) do
    {given_switches, [text], _} =
      label
      |> to_arguments()
      |> OptionParser.parse(
        strict: @valid_switches,
        aliases: @aliases
      )

    {apply(given_switches), text}
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
end
