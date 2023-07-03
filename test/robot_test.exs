defmodule RobotTest do
  use ExUnit.Case
  doctest Robot

  alias Robot.Game

  setup do
    {:ok, game} = Game.new({:place, {{0, 0}, :north}})

    %{
      game: game
    }
  end

  test "run" do
    assert run("""
                  PLACE 0,0,NORTH
                  MOVE
                  REPORT
           """) == "0,1,NORTH"

    assert run("""
           PLACE 0,0,NORTH
           LEFT
           REPORT
           """) == "0,0,WEST"

    assert run("""
           PLACE 1,2,EAST
           MOVE
           MOVE
           LEFT
           MOVE
           REPORT
           """) == "3,3,NORTH"
  end

  test "multiple reports" do
    assert run("""
           PLACE 1,2,EAST
           MOVE
           MOVE
           LEFT
           MOVE
           REPORT
           MOVE
           LEFT
           MOVE
           REPORT
           MOVE
           REPORT
           """) == """
           3,3,NORTH
           2,4,WEST
           1,4,WEST\
           """
  end

  test "ignores invalid placements" do
    assert run("""
           PLACE 1,6,WEST
           MOVE
           PLACE 3,3,EAST
           MOVE
           MOVE
           RIGHT
           MOVE
           REPORT
           """) == "4,2,SOUTH"
  end

  def run(instructions) do
    game =
      case Robot.run(instructions) do
        %Game{} = game -> game
      end

    Enum.reverse(game.reports)
    |> Enum.join("\n")
  end
end
