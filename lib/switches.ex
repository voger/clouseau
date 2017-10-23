defmodule Clouseau.Switches do
  @valid_switches [
              file:      :boolean,
              full_path: :boolean,
              module:    :boolean,
              line:      :boolean,
              text:      :boolean,
              border:    :boolean
            ]

  @aliases [
              f: :file,
              m: :module,
              l: :line,
              t: :text,
              b: :border
           ]

  @default_switches [
              file:      true,
              full_path: false,
              module:    true,
              line:      true,
              text:      true,
              border:    false
           ]

  @no_switches Enum.map(@default_switches, fn {key, _} -> {key, false} end)

  def valid_switches, do: @valid_switches
  def aliases, do: @aliases

  def default_switches do
    merge(no_switches(),
      Application.get_env(:clouseau, :default_switches, @default_switches))
  end

  def no_switches, do: @no_switches

  def apply(switches) do
    merge(default_switches(), switches)
  end

  defp merge(current_switches, new_switches)
    when is_list(current_switches) and is_list(new_switches)  do
    Keyword.merge(current_switches, new_switches)
  end
end
