defmodule Robot.Game do
  defstruct [:robot_position, :robot_orientation]
  @board_cols 5
  @board_rows 5
  @facings [:north, :east, :south, :west]

  alias __MODULE__

  defguard valid_x?(x) when is_integer(x) and x >= 0 and x < @board_cols
  defguard valid_y?(y) when is_integer(y) and y >= 0 and y < @board_rows
  defguard valid_facing?(facing) when facing in @facings

  def valid_position?({x, y}) do
    valid_x?(x) and valid_y?(y)
  end

  def new({:place, {{x, y}, facing}}) do
    game = %Game{robot_position: {x, y}, robot_facing: facing}

    if valid?(game) do
      {:ok, game}
    else
      {:error, "Invalid starting position"}
    end
  end

  def valid?(%Game{robot_position: {x, y}, robot_facing: facing})
      when valid_x?(x) and valid_y?(y) and valid_facing?(facing) do
    true
  end

  def valid?(%Game{}), do: false
end
