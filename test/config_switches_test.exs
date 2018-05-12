defmodule ConfigSwitchesTest do
  use ClouseauCase

  setup_all do
    env_switches = Application.get_env(:clousau, :default_switches)

    # Put old switches back
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
    update_switches()

    io_inspect =
      capture_io(fn ->
        IO.inspect(@shopping_list)
      end)

    cl_inspect = capture_output("", @shopping_list)
    assert String.equivalent?(io_inspect, cl_inspect)
  end

  test "No file name but the rest is ok" do
    update_switches([file: false, module: true, line: true, text: true])
    cl_inspect = capture_output("The Shopping list", @shopping_list)
                 |> IO.inspect

    file_name = __ENV__.file |> Path.relative_to(File.cwd!())
    file_string = "\e[34m#{file_name}\e[0m\n"
    refute String.starts_with?(cl_inspect, file_string)
  end


  defp capture_output(label, term) when is_binary(label) do
    capture_io(fn ->
      Cl.inspect(term, label: label)
    end)
  end

  defp update_switches(new_switches \\ []) when is_list(new_switches) do
    no_switches = [
      file: false,
      module: false,
      line: false,
      border: false,
      colors: false
    ]

    Application.put_env(
      :clouseau,
      :default_switches,
      Keyword.merge(no_switches, new_switches)
    )

    # Recompile with our new switches
    Kernel.ParallelCompiler.compile(["lib/switches.ex"])
  end
end
