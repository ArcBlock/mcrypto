defmodule Mcrypto.Hasher.Sha3 do
  @moduledoc """
  sha3 hash functionality
  """

  use TypedStruct

  @typedoc """
  Sha3 data structure contains the following keys:

  * `:name`: hasher name
  * `:size`: size of hash
  * `:round`: how many rounds of hashing do we do
  """
  typedstruct do
    field(:name, atom(), default: :sha3)
    field(:size, non_neg_integer(), default: 256)
    field(:round, non_neg_integer(), default: 1)
  end
end

defimpl Mcrypto.Hasher, for: Mcrypto.Hasher.Sha3 do
  @doc """
  Support sha3 hash for size 224, 256, 384, 512.
  """
  [224, 256, 384, 512]
  |> Enum.map(fn size ->
    fun_init = :"sha3_#{size}_init"
    fun_update = :"sha3_#{size}_update"
    fun_final = :"sha3_#{size}_final"

    def hash(%{size: unquote(size), round: 0}, final), do: final

    def hash(%{size: unquote(size), round: round}, data) do
      sponge0 = apply(:libdecaf, unquote(fun_init), [])
      sponge1 = apply(:libdecaf, unquote(fun_update), [sponge0, data])
      hash = apply(:libdecaf, unquote(fun_final), [sponge1])
      hash(%{size: unquote(size), round: round - 1}, hash)
    end
  end)
end
