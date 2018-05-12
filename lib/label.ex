defmodule Clouseau.Label do
  alias Clouseau.Fields
  alias Clouseau.Render

  @moduledoc false

  @doc """
   Takes a string containing text and the appropriate switches and
   renders is according to the given switches by using a template.

   string is the label coming from the user
   caller is a `__ENV__` struct

   Returns a tuple {switches, label} where:
     switches is a keyword list with the switches used to render the template
     label is the rendered template
  """
  def render(text, switches, caller) do
    caller
    |> Fields.new(text, switches)
    |> Render.label()
  end
end
