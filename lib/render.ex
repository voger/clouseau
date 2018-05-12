defmodule Clouseau.Render do
  require EEx
  @moduledoc false

  @default_template """
    <% import IO.ANSI %>
    <%= if has_val?(file), do: from_iolist [:blue,  @file, :reset, "\n"] %>
    <%= if has_val?(module), do: from_iolist [:green, @module, ":"] %>
    <%= if has_val?(line), do:  from_iolist [:red, @line] %>
    <%= if has_val?(module) || has_val?(line), do: from_iolist [:reset, "\n"] %>
    <%= if has_val?(text), do: from_iolist [:yellow, @text, :reset, ": "] %>
  """

  def label(assigns) do
    template = Application.get_env(:clouseau, :template, @default_template)
    EEx.eval_string(template, [assigns: assigns], engine: Clouseau.TemplateEngine, trim: true)
  end
end
