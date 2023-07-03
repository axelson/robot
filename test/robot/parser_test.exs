defmodule Robot.ParserTest do
  use ExUnit.Case
  alias Robot.Parser

  test "left" do
    assert Parser.parse("LEFT") == {:ok, [:left]}
  end

  test "right" do
    assert Parser.parse("RIGHT") == {:ok, [:right]}
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
           """) == {:ok, [:left, :right]}
  end

  test "report command" do
    assert Parser.parse("REPORT") == {:ok, [:report]}
  end

  test "move command" do
    assert Parser.parse("MOVE") == {:ok, [:move]}
  end

  test "short" do
    assert Parser.parse("""
           MOVE
           PLACE 3,3,EAST
           """) == {:ok, [:move, {:place, {{3, 3}, :east}}]}
  end

  test "short2" do
    assert Parser.parse("PLACE 3,3,EAST") == {:ok, [{:place, {{3, 3}, :east}}]}
  end

  test "full command list" do
    assert Parser.parse("""
                  PLACE 1,6,WEST
                  MOVE
                  PLACE 3,3,EAST
                  MOVE
                  MOVE
                  RIGHT
                  MOVE
                  REPORT
           """) ==
             {:ok,
              [
                {:place, {{1, 6}, :west}},
                :move,
                {:place, {{3, 3}, :east}},
                :move,
                :move,
                :right,
                :move,
                :report
              ]}
  end
end
