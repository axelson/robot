defmodule Robot.GameTest do
  use ExUnit.Case

  alias Robot.Game
  @valid_position {0, 0}
  @valid_facing :north
  @valid_game %Game{robot_position: @valid_position, robot_facing: @valid_facing}

  describe "valid?/1" do
    test "valid based on column and row" do
      valid_positions = for x <- 0..4, y <- 0..4, do: {x, y}

      for {x, y} <- valid_positions do
        assert Game.valid?(%Game{robot_position: {x, y}, robot_facing: @valid_facing}) ==
                 true
      end
    end

    test "invalid positions" do
      assert Game.valid?(%Game{robot_position: {-1, 0}, robot_facing: @valid_facing}) ==
               false

      assert Game.valid?(%Game{robot_position: {6, 0}, robot_facing: @valid_facing}) ==
               false

      assert Game.valid?(%Game{robot_position: {0, -1}, robot_facing: @valid_facing}) ==
               false

      assert Game.valid?(%Game{robot_position: {0, 6}, robot_facing: @valid_facing}) ==
               false
    end

    test "valid facings" do
      assert Game.valid?(%Game{@valid_game | robot_facing: :north}) == true
      assert Game.valid?(%Game{@valid_game | robot_facing: :east}) == true
      assert Game.valid?(%Game{@valid_game | robot_facing: :south}) == true
      assert Game.valid?(%Game{@valid_game | robot_facing: :west}) == true
    end

    test "invalid facings" do
      assert Game.valid?(%Game{@valid_game | robot_facing: :left}) == false
      assert Game.valid?(%Game{@valid_game | robot_facing: 1}) == false
      assert Game.valid?(%Game{@valid_game | robot_facing: nil}) == false
    end
  end
end
