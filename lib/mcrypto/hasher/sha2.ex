defmodule Mcrypto.Hasher.Sha2 do
  @moduledoc """
  sha2 hash functionality
  """

  use TypedStruct

  @typedoc """
  Sha2 data structure contains the following keys:

  * `:name`: hasher name
  * `:size`: size of hash
  * `:round`: how many rounds of hashing do we do
  """
  typedstruct do
    field(:name, atom(), default: :sha2)
    field(:size, non_neg_integer(), default: 256)
    field(:round, non_neg_integer(), default: 2)
  end
end

defimpl Mcrypto.Hasher, for: Mcrypto.Hasher.Sha2 do
  @doc """
  Support sha2 hash for size 224, 256, 384, 512. For sha2 we do double hash by default to prevent length extension attack. See: https://en.wikipedia.org/wiki/Length_extension_attack
  """
  [224, 256, 384, 512]
  |> Enum.map(fn size ->
    fun = :"sha#{size}"

    def hash(%{size: unquote(size), round: 0}, final), do: final

    def hash(%{size: unquote(size), round: round}, data) do
      hash = apply(:crypto, :hash, [unquote(fun), data])
      hash(%{size: unquote(size), round: round - 1}, hash)
    end
  end)
end
