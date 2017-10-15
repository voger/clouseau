defmodule Clouseau.Render do
  require EEx

  @default_template  """
                       <%=  %>
                       <%= if @file, do: IO.ANSI.blue() <> @file <> "\n" %>   %>
                       <%= if @module, do: IO.ANSI.green() <> @module %><%= if (@module && @line), do: ":" %>
                       <%= if @line, do: IO.ANSI.yellow() <> @line %>
                       <%= IO.ANSI.reset() <> "\n" %>
                    """

  EEx.function_from_string(:def, :location, Application.get_env(:clouseau, :template, @default_template),
    [:assigns], engine: Clouseau.TemplateEngine, trim: true)
end
