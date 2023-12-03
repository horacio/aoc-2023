{:ok, contents} = File.read("/Users/kappa/Code/Elixir/AoC/Day 2/input.txt")

defmodule ParsingHelper do
  @max_values %{
    red: 12,
    green: 13,
    blue: 14
  }

  defp parse_game_id(game) do
    ~r/^Game \K(?<id>\d+)/
    |> Regex.named_captures(game)
  end

  def parse_game_sets(game) do
    res = parse_game_id(game)

    sets =
      game
      |> String.split(";")
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn set ->
        Regex.scan(~r/(?<quantity>\d+)\s+(?<color>\w+)/, set)
        |> Enum.reduce(%{}, fn [_match, quantity, color], acc ->
          Map.put(acc, String.to_atom(color), String.to_integer(quantity))
        end)
      end)

    Map.put(res, "sets", sets)
  end

  def calculate(%{"sets" => sets} = _game) do
    Enum.all?(sets, fn set ->
      Enum.all?(Map.keys(set), fn k ->
        Map.get(set, k) <= Map.get(@max_values, k)
      end)
    end)
  end
end

contents
|> String.split(~r/\n/)
|> Enum.reverse()
|> tl()
|> Enum.reverse()
|> Enum.map(&ParsingHelper.parse_game_sets/1)
|> Enum.filter(&ParsingHelper.calculate/1)
|> Enum.map(fn game -> String.to_integer(Map.get(game, "id")) end)
|> Enum.sum()
