defmodule Cl do

  if Mix.env() in [:dev, :test] do
    alias Clouseau.Render

    @options_map %{
      "f" => :file,
      "l" => :line,
      "m" => :module
    }

    @valid_options @options_map |> Map.keys() |> Enum.join("")

    Enum.each(@options_map, fn {option, key} ->
      defp context_attribute(unquote(option), caller_context) do
        {unquote(key), Map.get(caller_context, unquote(key))}
      end
    end)


    defmacro inspector(item, opts \\ []) do

        caller_context = %{
        :file => __CALLER__.file,
        :module => to_string(__CALLER__.module),
        :line => to_string(__CALLER__.line)}

        label =
          opts
          |> Keyword.get(:label)
          |> render_label(caller_context)

        opts = Keyword.update(opts, :label, nil, fn _ -> label end)

        quote do
          IO.inspect unquote(item), unquote(opts)
        end
    end


    defp render_label(nil, _), do: nil

    defp render_label(binary, caller_context) do
      case  String.split(binary, ~r/\h?\|\h?/, parts: 2)  do
        [params, label] ->
          create_location_string(params, caller_context) <> label

        [label] ->
          params = Application.get_env(:clouseau, :default_params, @valid_options)
          create_location_string(params, caller_context) <> label
      end
    end


    defp create_location_string(params, caller_context) do
      valid_params_regex = ~r/^[#{@valid_options}]*$/
      normalized_params = params |> String.downcase() |> String.replace(" ", "")

      if Regex.match?(valid_params_regex, normalized_params) do
        normalized_params
        |> create_assigns(caller_context)
        |> Render.location()
      else
        options = String.graphemes(@valid_options)
        "valid params are #{inspect options} and <Spc>:"
      end
    end


    defp create_assigns(params, caller_context) do
      params
      |> String.graphemes()
      |> Enum.map(fn c ->
        context_attribute(c, caller_context)
      end)
    end

  else
    defmacro inspector(item, _opts \\ []), do: item
  end
end
