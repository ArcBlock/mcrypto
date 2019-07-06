defmodule Mcrypto.Signer.Ed25519 do
  @moduledoc """
  Support ED25519 algorithm.
  """

  use TypedStruct

  @typedoc """
  Ed25519 data structure contains the following keys:

  * `:name`: signer name
  """
  typedstruct do
    field(:name, atom(), default: :ed25519)
  end
end

defimpl Mcrypto.Signer, for: Mcrypto.Signer.Ed25519 do
  def keypair(_signer) do
    :libdecaf_curve25519.eddsa_keypair()
  end

  def sk_to_pk(_signer, sk) do
    :libdecaf_curve25519.eddsa_sk_to_pk(sk)
  end

  def sign!(_signer, data, sk) do
    :libdecaf_curve25519.ed25519_sign(data, sk)
  end

  def verify(_signer, data, signature, pk) do
    :libdecaf_curve25519.ed25519_verify(signature, data, pk)
  end
end
