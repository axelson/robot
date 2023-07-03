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
      Game.command(game, command)
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
end
