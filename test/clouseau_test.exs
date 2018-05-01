defmodule ClouseauTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  require Cl

  @shopping_list %{
    :eggs => 6,
    "milk" => "1 liter",
    7 => 2,
    "bread" => [pita: 3, brioche: "half"]
  }

  test "displays correct info" do
    result =
      capture_io(fn ->
        Cl.inspect(@shopping_list, label: "The shopping list")
      end)
      |> String.split("\n", trim: true)

    # WARNING: The next line should be always be 5 lines below the Cl.inspect otherwise the test will fail
    line = __ENV__.line - 5
    file = __ENV__.file
    module = __ENV__.module |> to_string |> String.trim_leading("Elixir.")

    # Displays correct filename with correct colors
    {first_line, result} = List.pop_at(result, 0)
    {:ok, dir} = File.cwd()
    filename = Path.relative_to(file, dir)
    assert first_line == IO.ANSI.format_fragment([:blue, filename], true) |> Enum.join()

    # Displays correct module and correct line with correct colors
    {second_line, result} = List.pop_at(result, 0)

    assert second_line ==
             IO.ANSI.format_fragment([:green, module, ":", :red, to_string(line)], true)
             |> Enum.join()

    IO.inspect(result)
  end
end
