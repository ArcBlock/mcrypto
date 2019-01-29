defmodule Mcrypto.Hasher.Keccak do
  @moduledoc """
  Keccakf1600 hash functionality
  """

  use TypedStruct

  @typedoc """
  Keccak data structure contains the following keys:

  * `:name`: hasher name
  * `:size`: size of hash
  * `:round`: how many rounds of hashing do we do
  """
  typedstruct do
    field(:name, atom(), default: :keccak)
    field(:size, non_neg_integer(), default: 256)
    field(:round, non_neg_integer(), default: 1)
  end
end

defimpl Mcrypto.Hasher, for: Mcrypto.Hasher.Keccak do
  @doc """
  Support keccakf1600 hash for size 224, 256, 384, 512.
  """

  [224, 256, 384, 512]
  |> Enum.map(fn size ->
    fun = :"sha3_#{size}"

    def hash(%{size: unquote(size), round: 0}, final), do: final

    def hash(%{size: unquote(size), round: round}, data) do
      hash = apply(:keccakf1600, :hash, [unquote(fun), data])
      hash(%{size: unquote(size), round: round - 1}, hash)
    end
  end)
end
