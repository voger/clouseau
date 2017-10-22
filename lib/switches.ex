defmodule Clouseau.Switches do
  @switches [
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

  def switches, do: @switches
  def aliases, do: @aliases

  def default_switches do
      Keyword.merge(@no_switches, Application.get_env(:clouseau, :default_switches, @default_switches))
 end

  def no_switches, do: @no_switches
end
