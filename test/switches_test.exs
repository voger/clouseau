defmodule SwitchesTest do
  use ClouseauCase

  setup_all do
    env_switches = Application.get_env(:clousau, :default_switches)

    Application.put_env(
      :clouseau,
      :default_switches,
      file: false,
      module: false,
      line: false,
      border: false,
      colors: false
    )

    Kernel.ParallelCompiler.compile(["lib/switches.ex"])

    on_exit(fn ->
      if env_switches do
        Application.put_env(:clouseau, :default_switches, env_switches)
      else
        Application.delete_env(:clouseau, :default_switches)
      end

      Kernel.ParallelCompiler.compile(["lib/switches.ex"])
      Application.get_env(:clousau, :default_switches)
    end)
  end

  test "Does not display any extra info" do
    [head | _] = capture_output("", @shopping_list)
    refute "\e[34m" <> Path.relative_to_cwd(__ENV__.file) == head |> IO.inspect
  end

  # test "from environment variables we can disable the file"

  defp capture_output(label, term) when is_binary(label) do
    capture_io(fn ->
      Cl.inspect(term, label: label)
    end)
    |> String.split("\n", trim: true)
  end
end
