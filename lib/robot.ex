defmodule Robot do
  alias Robot.Game

  require Logger
  require Robot.Game

  def run(instructions) do
    case Robot.Parser.parse(instructions) do
      {:ok, commands} ->
        case ignore_until_first_valid_place_command(commands) do
          {:ok, game} -> run_commands(game, commands)
          {:error, :all_invalid} = err -> err
        end

      {:error, _} = err ->
        err
    end
  end

  def run_commands(game, commands) do
    Enum.reduce(commands, game, fn command, game ->
      command(game, command)
    end)
  end

  def ignore_until_first_valid_place_command([]), do: {:error, :all_invalid}

  def ignore_until_first_valid_place_command([{:place, _} = place_command | rest]) do
    case Game.new(place_command) do
      {:ok, game} ->
        {:ok, game}

      {:error, _} ->
        ignore_until_first_valid_place_command(rest)
    end
  end

  def ignore_until_first_valid_place_command([_other_command | rest]) do
    ignore_until_first_valid_place_command(rest)
  end

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
    %Game{robot_position: {x, y}, robot_facing: facing} = game
    IO.puts(Enum.join([x, y, String.upcase(to_string(facing))], ","))
    game
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
