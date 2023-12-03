{:ok, contents} = File.read("/Users/kappa/Code/Elixir/AoC/Day 2/input.txt")

defmodule ParsingHelper do
  @max_values %{
    red: 12,
    green: 13,
    blue: 14
  }

  def parse_games(game) do
    res = parse_game_id(game)

    sets =
      game
      |> String.split(";")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&parse_sets/1)

    Map.put(res, "sets", sets)
  end

  defp parse_game_id(game) do
    ~r/^Game \K(?<id>\d+)/
    |> Regex.named_captures(game)
  end

  defp parse_sets(set) do
    Regex.scan(~r/(?<quantity>\d+)\s+(?<color>\w+)/, set)
    |> Enum.reduce(%{}, fn [_match, quantity, color], acc ->
      Map.put(acc, String.to_atom(color), String.to_integer(quantity))
    end)
  end

  def game_is_possible?(%{"sets" => sets}) do
    Enum.all?(sets, fn set ->
      Enum.all?(set, fn {key, value} ->
        value <= Map.get(@max_values, key)
      end)
    end)
  end
end

contents
|> String.trim_trailing()
|> String.split("\n")
|> Enum.map(&ParsingHelper.parse_games/1)
|> Enum.filter(&ParsingHelper.game_is_possible?/1)
|> Enum.map(&String.to_integer(Map.get(&1, "id")))
|> Enum.sum()
