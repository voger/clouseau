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


  EEx.function_from_string(:def, :label, Application.get_env(:clouseau, :template, @default_template),
    [:assigns], engine: Clouseau.TemplateEngine, trim: true)

end
