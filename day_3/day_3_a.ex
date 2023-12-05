defmodule MatrixHelper do
  @dx [0, 0, -1, 1, -1, -1, 1, 1]
  @dy [-1, 1, 0, 0, -1, 1, -1, 1]
  # Regex.scan(~r/[^.\d\/\n]/, tmp)
  # |> Enum.uniq()
  # |> List.flatten()
  # |> Enum.join("")
  @symbols "*&@+#$%=-"

  def process_matrix(matrix) do
    Enum.with_index(matrix, fn row, i ->
      Enum.with_index(row, fn value, j ->
        if String.contains?(@symbols, value), do: process_cell(matrix, i, j)
      end)
    end)
  end

  defp process_cell(matrix, i, j) do
    Enum.each(0..(length(@dx) - 1), fn k ->
      new_i = i + Enum.at(@dx, k)
      new_j = j + Enum.at(@dy, k)

      if is_valid_position?(matrix, new_i, new_j) do
        adjacent_value = get_value(matrix, new_i, new_j)

        case Integer.parse(adjacent_value) do
          {number, _} -> IO.inspect(number)
          :error -> nil
        end
      end
    end)
  end

  defp is_valid_position?(matrix, i, j) do
    i in 0..(length(matrix) - 1) and j in 0..9
  end

  defp get_value(matrix, i, j) do
    Enum.at(Enum.at(matrix, i), j)
  end
end

{:ok, contents} = File.read("/Users/kappa/Code/Elixir/AoC/day_3/test.txt")

contents
|> String.trim_trailing()
|> String.split("\n")
|> Enum.map(fn line ->
  Regex.scan(~r/[*&@+#$%=.-]|\d+/, line)
  |> Enum.map(fn [match] -> match end)
end)
|> Enum.reduce([], fn sublist, acc ->
  acc ++
    Enum.flat_map(sublist, fn el ->
      case Integer.parse(el) do
        {_number, _} -> Enum.map(1..String.length(el), fn _ -> el end)
        :error -> [el]
      end
    end)
end)
|> Enum.chunk_every(10)
|> MatrixHelper.process_matrix()
