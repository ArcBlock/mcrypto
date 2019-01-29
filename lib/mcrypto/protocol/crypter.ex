defprotocol Mcrypto.Crypter do
  @moduledoc """
  Provide encryption functionality
  """
  @type t :: Mcrypto.Crypter.t()

  @doc "encrypt a plaintext with secret key"
  @spec encrypt(t(), binary(), binary()) :: [iv: String.t(), ciphertext: String.t()]
  def encrypt(crypter, plaintext, key)

  @doc "decrypt a ciphertext with secret key and iv"
  @spec decrypt(t(), binary(), binary(), binary()) :: binary()
  def decrypt(crypter, cyphertext, key, iv)
end
