defprotocol Mcrypto.Signer do
  @moduledoc """
  Provide sign functionality
  """
  @type t :: Mcrypto.Signer.t()

  @doc "create a keypair for a given preset"
  @spec keypair(t()) :: {binary(), binary()}
  def keypair(signer)

  @doc "craete pk based on sk"
  @spec sk_to_pk(t(), binary()) :: binary()
  def sk_to_pk(signer, sk)

  @doc "sign a piece of data with secret key"
  @spec sign!(t(), binary(), binary()) :: binary()
  def sign!(signer, data, sk)

  @doc "verify data against a signature with public key"
  @spec verify(t(), binary(), binary(), binary()) :: true | false
  def verify(signer, data, signature, pk)
end
