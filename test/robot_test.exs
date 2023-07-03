defmodule RobotTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
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
    output =
      capture_io(fn ->
        case Robot.run(instructions) do
          %Game{} = game -> game
        end
      end)

    String.trim(output)
  end
end
