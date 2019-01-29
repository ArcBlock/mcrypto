defmodule Mcrypto do
  @moduledoc """
  Multiple crypto support for Forge.
  """

  defdelegate hash(hasher, data), to: Mcrypto.Hasher

  defdelegate keypair(signer), to: Mcrypto.Signer
  defdelegate sk_to_pk(signer, sk), to: Mcrypto.Signer
  defdelegate sign!(signer, data, sk), to: Mcrypto.Signer
  defdelegate verify(signer, data, signature, pk), to: Mcrypto.Signer

  defdelegate encrypt(crypter, plaintext, key), to: Mcrypto.Crypter
  defdelegate decrypt(crypter, cyphertext, key, iv), to: Mcrypto.Crypter
end
