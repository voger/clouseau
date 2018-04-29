defmodule ClauseauTest do
  use ExUnit.Case

  require Cl

  @shopping_list %{
    :eggs => 6,
    "milk" => "1 liter",
    7 => 2,
    "bread" => [pita: 3, brioche: "half"]
  }

  test "displays correct info" do

    assert __ENV__.line =~ Cl.inspect(@shopping_list, label: "The shopping list")
  end

end
