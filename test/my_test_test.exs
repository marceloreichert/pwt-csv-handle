defmodule MyTestTest do
  use ExUnit.Case
  doctest MyTest

  test "3 estados com mais cidades" do

    result = %{
      state1: %{count: 853, state: "MG"},
      state2: %{count: 645, state: "SP"},
      state3: %{count: 497, state: "RS"}
    }

    assert MyTest.handle_csv == result
  end
end
