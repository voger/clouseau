defmodule Clouseau.Render do
  require EEx

  @default_template  """
                       <% import IO.ANSI %>
                       <%= if has_val?(file), do: blue() <> @file <> "\n" %>
                       <%= green() <> @module %><%=  if has_val?(module), do: ":" %>
                       <%= red() <> @line %>
                       <%= if has_val?(module) || has_val?(line), do: "\n" %>
                       <%= yellow()  <> @text <> reset() %><%= if has_val?(text), do: ": " %>
                       <%= reset()  %>
                    """



  def label(assigns) do
    template = Application.get_env(:clouseau, :template, @default_template)
    EEx.eval_string(template, [assigns: assigns], engine: Clouseau.TemplateEngine, trim: true)
  end

end
