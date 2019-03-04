defmodule Mcrypto.Hasher.Blake2b do
  @moduledoc """
  Blake2b hash functionality
  """

  use TypedStruct

  @typedoc """
  Blake2b data structure contains the following keys:

  * `:name`: hasher name
  * `:size`: size of hash
  * `:round`: how many rounds of hashing do we do
  """
  typedstruct do
    field(:name, atom(), default: :blake2b)
    field(:size, non_neg_integer(), default: 256)
    field(:round, non_neg_integer(), default: 1)
  end
end

defimpl Mcrypto.Hasher, for: Mcrypto.Hasher.Blake2b do
  @doc """
  Support blake2b hash for size 160, 256, 384, 512.
  """

  [160, 256, 384, 512]
  |> Enum.map(fn size ->
    bytes_size = div(size, 8)

    def hash(%{size: unquote(size), round: 0}, final), do: final

    def hash(%{size: unquote(size), round: round}, data) do
      hash = Blake2.hash2b(data, unquote(bytes_size))
      hash(%{size: unquote(size), round: round - 1}, hash)
    end
  end)
end
