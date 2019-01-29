defmodule McryptoTest.Secp256k1 do
  use ExUnit.Case
  alias Mcrypto.Signer.Secp256k1

  test "create keypair for secp256k1" do
    signer = %Secp256k1{}

    {pk, sk} = Mcrypto.keypair(signer)
    {:ok, pk1} = :libsecp256k1.ec_pubkey_create(sk, :uncompressed)

    assert pk1 === pk
  end

  test "signature shall be verified" do
    signer = %Secp256k1{}
    {pk, sk} = Mcrypto.keypair(signer)

    signature = Mcrypto.sign!(signer, "hello world", sk)
    assert Mcrypto.verify(signer, "hello world", signature, pk) === true
  end
end
