defmodule ClouseauTest do
  use ClouseauCase
  import ExUnit.CaptureIO


  test "displays correct info" do
    label = "The shopping list"

    result =
      capture_io(fn ->
        Cl.inspect(@shopping_list, label: label)
      end)
      |> String.split("\n", trim: true)

    # WARNING: The next line must be always be 5 lines below the Cl.inspect otherwise the test will fail
    line = __ENV__.line - 5
    file = __ENV__.file
    module = __ENV__.module |> to_string |> String.trim_leading("Elixir.")

    # Displays correct filename with correct colors
    {first_line, result} = List.pop_at(result, 0)
    {:ok, dir} = File.cwd()
    filename = Path.relative_to(file, dir)

    assert first_line ==
             IO.ANSI.format_fragment([:blue, filename, :reset], true) |> IO.iodata_to_binary()

    # Displays correct module and correct line with correct colors
    {second_line, result} = List.pop_at(result, 0)

    assert second_line ==
             IO.ANSI.format_fragment([:green, module, ":", :red, to_string(line), :reset], true)
             |> IO.iodata_to_binary()

    # Displays correct text with colors and then resets to show ":"
    {third_line, result} = List.pop_at(result, 0)

    assert String.starts_with?(third_line, "\e[33mThe shopping list\e[0m: ")

    # Displays the term exactly as IO.inspect
    assert (["%{"] ++ result ++ [""]) |> Enum.join("\n") ==
             capture_io(fn ->
               IO.inspect(@shopping_list)
             end)
  end
end
