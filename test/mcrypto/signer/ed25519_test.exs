defmodule McryptoTest.Ed25519 do
  use ExUnit.Case
  alias Mcrypto.Signer.Ed25519

  test "create keypair for ed25519" do
    signer = %Ed25519{}

    {pk, sk} = Mcrypto.keypair(signer)
    assert pk === :libdecaf_curve25519.eddsa_sk_to_pk(sk)
  end

  test "sk to pk should work" do
    signer = %Ed25519{}

    {pk, sk} = Mcrypto.keypair(signer)
    assert pk === Mcrypto.sk_to_pk(signer, sk)
  end

  test "signature shall be verified" do
    signer = %Ed25519{}
    {pk, sk} = Mcrypto.keypair(signer)

    signature = Mcrypto.sign!(signer, "hello world", sk)
    assert Mcrypto.verify(signer, "hello world", signature, pk) === true
  end
end
