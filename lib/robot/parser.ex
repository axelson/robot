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
  {:ok, :left}

  iex> Robot.Parser.parse("RIGHT")
  {:ok, :right}
  """
  import NimbleParsec

  whitespace = ascii_char([?\s, ?\t, ?\n]) |> times(min: 1)

  left_command =
    ignore(optional(whitespace))
    |> string("LEFT")
    |> replace(:left)

  right_command =
    ignore(optional(whitespace))
    |> string("RIGHT")
    |> replace(:right)

  report_command =
    ignore(optional(whitespace))
    |> string("REPORT")
    |> replace(:report)

  move_command =
    ignore(optional(whitespace))
    |> string("MOVE")
    |> replace(:move)

  digits = [?0..?9] |> ascii_string(min: 1) |> label("digits")

  int =
    digits
    |> reduce(:to_integer)
    |> label("integer")

  defp to_integer(acc), do: acc |> Enum.join() |> String.to_integer(10)

  facing =
    choice([
      string("NORTH"),
      string("EAST"),
      string("SOUTH"),
      string("WEST")
    ])
    |> reduce(:to_facing)

  defp to_facing(["NORTH"]), do: :north
  defp to_facing(["EAST"]), do: :east
  defp to_facing(["SOUTH"]), do: :south
  defp to_facing(["WEST"]), do: :west

  place_command =
    ignore(optional(whitespace))
    |> ignore(string("PLACE"))
    |> ignore(string(" "))
    |> concat(int)
    |> ignore(string(","))
    |> concat(int)
    |> ignore(string(","))
    |> concat(facing)
    |> reduce(:to_place)
    |> unwrap_and_tag(:place)

  def to_place([x, y, facing]) do
    {{x, y}, facing}
  end

  defparsec(:place, place_command)

  line = [left_command, right_command, place_command, report_command, move_command] |> choice()
  defparsec(:raw_parse, repeat(line))

  def parse(string) do
    string
    |> String.trim()
    |> raw_parse()
    |> unwrap_result()
  end

  defp unwrap_result(result) do
    case result do
      {:ok, acc, "", _, _line, _offset} ->
        {:ok, acc}

      {:ok, _, rest, _, _line, _offset} ->
        {:error, "could not parse: " <> rest}
    end
  end
end
