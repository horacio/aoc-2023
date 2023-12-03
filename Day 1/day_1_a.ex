{:ok, contents} = File.read("/Users/kappa/Code/Elixir/AoC/Day 1/input.txt")

contents
|> String.split(~r/\n/)
|> Enum.map(fn s -> Regex.scan(~r/\d+/, s) end)
|> Enum.map(&Enum.join/1)
|> Enum.map(fn s -> [String.at(s, 0), String.at(s, -1)] end)
|> Enum.map(fn l -> Enum.join(l) end)
|> Enum.map(fn n ->
  case Integer.parse(n) do
    {int, _rest} -> int
    _ -> 0
  end
end)
|> Enum.sum()
