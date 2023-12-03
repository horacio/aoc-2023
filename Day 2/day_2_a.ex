{:ok, contents} = File.read("/Users/kappa/Code/Elixir/AoC/Day 2/input.txt")

defmodule ParsingHelper do
  @max_values %{
    red: 12,
    green: 13,
    blue: 14
  }

  def get_possible_games(games) do
    games
    |> Enum.map(&parse_game/1)
    |> Enum.filter(&game_is_possible?/1)
  end

  def get_fewest_possible_cubes(games) do
    games
    |> Enum.map(&parse_game/1)
    |> Enum.map(&Map.get(&1, "sets"))
    |> Enum.map(fn list ->
      Enum.reduce(list, %{}, fn m, acc ->
        Map.merge(acc, m, fn _k, v1, v2 ->
          if v2 > v1, do: v2, else: v1
        end)
      end)
    end)
  end

  def parse_game(game) do
    res = parse_game_id(game)

    sets =
      game
      |> String.split(";")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&parse_sets/1)

    Map.put(res, "sets", sets)
  end

  def parse_game_id(game) do
    ~r/^Game \K(?<id>\d+)/
    |> Regex.named_captures(game)
  end

  def parse_sets(set) do
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
|> ParsingHelper.get_fewest_possible_cubes()
|> Enum.map(fn r ->
  Enum.reduce(Map.values(r), 1, fn x, acc -> x * acc end)
end)
|> Enum.sum()
