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

  def sign!(_signer, data, sk) do
    case byte_size(data) do
      32 -> :crypto.sign(:ecdsa, :sha256, {:digest, data}, [sk, :secp256k1])
      48 -> :crypto.sign(:ecdsa, :sha384, {:digest, data}, [sk, :secp256k1])
      64 -> :crypto.sign(:ecdsa, :sha512, {:digest, data}, [sk, :secp256k1])
      _ -> raise("Sign data with size #{byte_size(data)} is not supported.")
    end
  end

  def verify(_signer, data, signature, pk) do
    case byte_size(data) do
      32 -> :crypto.verify(:ecdsa, :sha256, {:digest, data}, signature, [pk, :secp256k1])
      48 -> :crypto.verify(:ecdsa, :sha384, {:digest, data}, signature, [pk, :secp256k1])
      64 -> :crypto.verify(:ecdsa, :sha512, {:digest, data}, signature, [pk, :secp256k1])
      _ -> raise("Verify data with size #{byte_size(data)} is not supported.")
    end
  end
end
