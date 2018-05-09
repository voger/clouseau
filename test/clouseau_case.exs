defmodule ClouseauCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import ExUnit.CaptureIO
      require Cl

      @shopping_list %{
        :eggs => 6,
        "milk" => %{quantity: 1, unit: "liter"},
        7 => 2,
        "bread" => [pita: 3, brioche: "half"]
      }
    end
  end
end
