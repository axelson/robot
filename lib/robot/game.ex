defmodule Robot.Game do
  defstruct [:robot_position, :robot_orientation]
  @board_cols 5
  @board_rows 5
  @orientations [:north, :east, :south, :west]

  defguard valid_x?(x) when is_integer(x) and x >= 0 and x < @board_cols
  defguard valid_y?(y) when is_integer(y) and y >= 0 and y < @board_rows
  defguard valid_orientation?(orientation) when orientation in @orientations

  def valid_position?({x, y}) do
    valid_x?(x) and valid_y?(y)
  end

  def new({:place, {{x, y}, facing}}) do
    game = %__MODULE__{robot_position: {x, y}, robot_orientation: facing}

    if valid?(game) do
      {:ok, game}
    else
      {:error, "Invalid starting position"}
    end
  end

  def valid?(%__MODULE__{robot_position: {x, y}, robot_orientation: orientation})
      when valid_x?(x) and valid_y?(y) and valid_orientation?(orientation) do
    true
  end

  def valid?(%__MODULE__{}), do: false
end
