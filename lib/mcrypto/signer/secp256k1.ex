defmodule Mcrypto.Signer.Secp256k1 do
  @moduledoc """
  support Secp256k1 algo
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
  def keypair(signer) do
    sk = :crypto.strong_rand_bytes(32)
    pk = sk_to_pk(signer, sk)
    {pk, sk}
  end

  def sk_to_pk(_signer, sk) do
    {:ok, pk} = :libsecp256k1.ec_pubkey_create(sk, :uncompressed)
    pk
  end

  def sign!(_signer, data, sk) do
    {:ok, signature, _} = :libsecp256k1.ecdsa_sign_compact(data, sk, :default, <<>>)
    signature
  end

  def verify(_signer, data, signature, pk) do
    :ok == :libsecp256k1.ecdsa_verify_compact(data, signature, pk)
  end
end
