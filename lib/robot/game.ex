defmodule Robot.Game do
  require Logger

  defstruct [:robot_position, :robot_facing, reports: []]

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

  def command(%Game{} = game, {:place, _} = place_command) do
    case Game.new(place_command) do
      {:ok, game} -> game
      # invalid place commands are ignored
      {:error, _} -> game
    end
  end

  def command(%Game{robot_facing: facing} = game, :left) do
    %Game{game | robot_facing: left(facing)}
  end

  def command(%Game{robot_facing: facing} = game, :right) do
    %Game{game | robot_facing: right(facing)}
  end

  def command(%Game{robot_position: pos, robot_facing: facing} = game, :move) do
    {x, y} = pos

    new_pos =
      case facing do
        :north -> {x, y + 1}
        :east -> {x + 1, y}
        :south -> {x, y - 1}
        :west -> {x - 1, y}
      end

    if Game.valid_position?(new_pos) do
      %Game{game | robot_position: new_pos}
    else
      Logger.debug("Ignoring invalid move")
      game
    end
  end

  def command(%Game{} = game, :report) do
    %Game{robot_position: {x, y}, robot_facing: facing, reports: reports} = game

    report = Enum.join([x, y, String.upcase(to_string(facing))], ",")
    %Game{game | reports: [report | reports]}
  end

  def left(:north), do: :west
  def left(:east), do: :north
  def left(:south), do: :east
  def left(:west), do: :south

  def right(:north), do: :east
  def right(:east), do: :south
  def right(:south), do: :west
  def right(:west), do: :north
end
