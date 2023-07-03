defmodule Robot.ParserTest do
  use ExUnit.Case
  alias Robot.Parser

  test "left" do
    assert Parser.parse("LEFT") == {:ok, [:turn_left]}
  end

  test "right" do
    assert Parser.parse("RIGHT") == {:ok, [:turn_right]}
  end

  test "place" do
    assert Parser.parse("PLACE 0,3,NORTH") == {:ok, [{:place, {{0, 3}, :north}}]}
    assert Parser.parse("PLACE 3,1,EAST") == {:ok, [{:place, {{3, 1}, :east}}]}
    assert Parser.parse("PLACE 5,3,SOUTH") == {:ok, [{:place, {{5, 3}, :south}}]}
    assert Parser.parse("PLACE 0,5,WEST") == {:ok, [{:place, {{0, 5}, :west}}]}
  end

  test "multiple commands" do
    assert Parser.parse("""
           LEFT
           RIGHT
           """) == {:ok, [:turn_left, :turn_right]}
  end
end
