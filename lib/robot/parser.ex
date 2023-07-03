defmodule Robot.Parser do
  @moduledoc """
  Parses robot instructions

  Instructions:

      PLACE X,Y,F
      MOVE
      LEFT
      RIGHT
      REPORT

  iex> Robot.Parser.parse("PLACE 1,3,NORTH")
  {:ok, {:place, {1, 3}, :north}}

  iex> Robot.Parser.parse("MOVE")
  {:ok, :move}

  iex> Robot.Parser.parse("LEFT")
  {:ok, :turn_left}

  iex> Robot.Parser.parse("RIGHT")
  {:ok, :turn_right}
  """
  import NimbleParsec

  left_command =
    string("LEFT")
|> replace(:turn_left)

  right_command = string("RIGHT")
  |> replace(:turn_right)

    digits = [?0..?9] |> ascii_string(min: 1) |> label("digits")

    place_command = string("PLACE ")
    |> concat(digits)
    |> ignore(string(","))
    |> concat(digits)
    |> ignore(string(","))

  line = [left_command, right_command, place_command] |> choice()
  defparsec(:raw_parse, line)

  def parse(string) do
    raw_parse(string)
    |> unwrap_result()
  end

  defp unwrap_result(result) do
    case result do
      {:ok, [acc], "", _, _line, _offset} ->
        {:ok, acc}

      {:ok, _, rest, _, _line, _offset} ->
        {:error, "could not parse: " <> rest}
    end
  end
end
