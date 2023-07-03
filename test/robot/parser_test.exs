defmodule Robot.ParserTest do
  use ExUnit.Case
  alias Robot.Parser

  test "abc" do
assert    Parser.parse("LEFT") == {:ok, :turn_left}
  end

  test "place" do
    assert Parser.parse("PLACE 0,1") == {:ok, {:place, {0, 1}}}
    end
end
