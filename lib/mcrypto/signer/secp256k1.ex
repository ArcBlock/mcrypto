defmodule Mcrypto.Signer.Secp256k1 do
  @moduledoc """
  Support Secp256k1 algorithm.
  """

  use TypedStruct

  @typedoc """
  Secp256k1 data structure contains the following keys:

  * `:name`: signer name
  """
  typedstruct do
    field(:name, atom(), default: :secp256k1)
  end
end

defimpl Mcrypto.Signer, for: Mcrypto.Signer.Secp256k1 do
  def keypair(_signer) do
    :crypto.generate_key(:ecdh, :secp256k1)
  end

  def sk_to_pk(_signer, _sk) do
    :not_support
  end

  def sign!(_signer, data, sk) when byte_size(data) == 32 do
    :crypto.sign(:ecdsa, :sha256, {:digest, data}, [sk, :secp256k1])
  end

  def verify(_signer, data, signature, pk) when byte_size(data) == 32 do
    :crypto.verify(:ecdsa, :sha256, {:digest, data}, signature, [pk, :secp256k1])
  end
end
