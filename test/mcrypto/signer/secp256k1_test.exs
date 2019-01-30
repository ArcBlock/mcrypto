defmodule McryptoTest.Secp256k1 do
  use ExUnit.Case
  alias Mcrypto.Signer.Secp256k1

  @signer %Secp256k1{}

  test "create keypair for secp256k1" do
    {pk, sk} = Mcrypto.keypair(@signer)
    {:ok, pk1} = :libsecp256k1.ec_pubkey_create(sk, :uncompressed)

    assert pk1 === pk
  end

  test "signature shall be verified" do
    {pk, sk} = Mcrypto.keypair(@signer)

    signature = Mcrypto.sign!(@signer, "hello world", sk)
    assert Mcrypto.verify(@signer, "hello world", signature, pk) === true
  end

  # Same secret key as https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses
  test "sk to pk" do
    sk = "18E14A7B6A307F426A94F8114701E7C8E774E7F9A47E2C2035DB29A206321725" |> Base.decode16!()

    # This is the uncompressed format of the public key
    pk =
      "0450863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B23522CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6"
      |> Base.decode16!()

    assert pk === Mcrypto.sk_to_pk(@signer, sk)
  end

  test "sign and verify" do
    sk = "18E14A7B6A307F426A94F8114701E7C8E774E7F9A47E2C2035DB29A206321725" |> Base.decode16!()

    # This is the uncompressed format of the public key
    pk =
      "0450863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B23522CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6"
      |> Base.decode16!()

    message =
      "15D0014A9CF581EC068B67500683A2784A15E1F68057E5E37AAF3A0F58F3C43F083D6A5630130399D4E5003EA191FDE30849"
      |> Base.decode16!()

    signature =
      "3045022100942F2DB25D6A0F6B01B195EDBAD8BB8F58F4EE85C7D5E1934649781D815F7ECE0220158DD32CB48D2A3A97267F4416A53692C51C72CD350F945D7BEA60376FD658D5"
      |> Base.decode16!()

    assert signature === Mcrypto.sign!(@signer, message, sk)
    assert Mcrypto.verify(@signer, message, signature, pk)
  end
end
