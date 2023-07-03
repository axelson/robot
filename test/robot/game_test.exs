defmodule Robot.GameTest do
  use ExUnit.Case

  alias Robot.Game
  @valid_position {0, 0}
  @valid_orientation :north
  @valid_game %Game{robot_position: @valid_position, robot_orientation: @valid_orientation}

  describe "valid?/1" do
    test "valid based on column and row" do
      valid_positions = for x <- 0..4, y <- 0..4, do: {x, y}

      for {x, y} <- valid_positions do
        assert Game.valid?(%Game{robot_position: {x, y}, robot_orientation: @valid_orientation}) ==
                 true
      end
    end

    test "invalid positions" do
      assert Game.valid?(%Game{robot_position: {-1, 0}, robot_orientation: @valid_orientation}) ==
               false

      assert Game.valid?(%Game{robot_position: {6, 0}, robot_orientation: @valid_orientation}) ==
               false

      assert Game.valid?(%Game{robot_position: {0, -1}, robot_orientation: @valid_orientation}) ==
               false

      assert Game.valid?(%Game{robot_position: {0, 6}, robot_orientation: @valid_orientation}) ==
               false
    end

    test "valid orientations" do
      assert Game.valid?(%Game{@valid_game | robot_orientation: :north}) == true
      assert Game.valid?(%Game{@valid_game | robot_orientation: :east}) == true
      assert Game.valid?(%Game{@valid_game | robot_orientation: :south}) == true
      assert Game.valid?(%Game{@valid_game | robot_orientation: :west}) == true
    end

    test "invalid orientations" do
      assert Game.valid?(%Game{@valid_game | robot_orientation: :left}) == false
      assert Game.valid?(%Game{@valid_game | robot_orientation: 1}) == false
      assert Game.valid?(%Game{@valid_game | robot_orientation: nil}) == false
    end
  end
end
