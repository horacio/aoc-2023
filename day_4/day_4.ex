# So card value seems to be 2^n where n is matches - 1
{:ok, contents} = File.read("/Users/kappa/Code/Elixir/AoC/day_4/input.txt")

contents
|> String.trim_trailing()
|> String.split("\n")
|> Enum.map(fn card ->
  [_card_id, lists] = String.split(card, ":")

  lists
  |> String.split("|")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.split/1)
end)
|> Enum.map(fn [winner_numbers, possible_winner_numbers] ->
  matches =
    Enum.count(possible_winner_numbers, fn x ->
      Enum.member?(winner_numbers, x)
    end)

  if matches > 1, do: :math.pow(2, matches - 1), else: matches
end)
|> Enum.sum()
