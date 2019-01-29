defprotocol Mcrypto.Hasher do
  @moduledoc """
  Provide hash functionality
  """
  @type t :: Mcrypto.Hasher.t()

  @doc "create a hash for a given preset"
  @spec hash(t(), binary()) :: binary()
  def hash(hasher, data)
end
