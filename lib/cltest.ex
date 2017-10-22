defmodule Clouseau.ClTest do
  require Cl


  [:test, :outside, :module] |> Cl.inspect

  for atom <- [{:random, :things, :here}, %{:random => 0, :things => "Testing", :here => [:a, :b, :c]}, :outside, :module] do
    Cl.inspect atom, syntax_colors: [atom: :magenta]
  end

  def inspect2() do
  fn a, b -> a + b end |> Cl.inspect


  end

  def inspect() do
    # Cl.inspect({"test", 7}, label: "-flmt test", syntax_colors: [number: :blue])
    # Cl.inspect({"test", 7, %{banana: :yellow}}, label: "--no-file Test showing only module and line")

    Cl.inspect({"test", 7, [banana: "split"]}, label: "--no-module --no-line -b Test showing only file")

    # Cl.inspect({"test", 7, 8}, label: " --no-module --no-line --no-file --full-path Test showing nothing")

    {"test", 7}
    |> Cl.inspect(label: "-b Test With border", syntax_colors: [number: :blue])

    # Cl.inspect({"test", 7, 8}, label: "-ft -b Test With border and file")
    # |> IO.inspect

    # Cl.inspect({"test", 7}, label: "-b Test With border only")






    # Cl.inspect("test2", label: " This is a test")
  end

end
