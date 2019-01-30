defmodule McryptoTest.Ed25519 do
  use ExUnit.Case
  alias Mcrypto.Signer.Ed25519

  @signer %Ed25519{}

  test "create keypair for ed25519" do
    {pk, sk} = Mcrypto.keypair(@signer)
    assert pk === :libdecaf_curve25519.eddsa_sk_to_pk(sk)
  end

  test "sk to pk should work" do
    {pk, sk} = Mcrypto.keypair(@signer)
    assert pk === Mcrypto.sk_to_pk(@signer, sk)
  end

  test "signature shall be verified" do
    {pk, sk} = Mcrypto.keypair(@signer)

    signature = Mcrypto.sign!(@signer, "hello world", sk)
    assert Mcrypto.verify(@signer, "hello world", signature, pk) === true
  end

  test "secret key to public key" do
    sk =
      "D67C071B6F51D2B61180B9B1AA9BE0DD0704619F0E30453AB4A592B036EDE644E4852B7091317E3622068E62A5127D1FB0D4AE2FC50213295E10652D2F0ABFC7"
      |> Base.decode16!()

    pk = "E4852B7091317E3622068E62A5127D1FB0D4AE2FC50213295E10652D2F0ABFC7" |> Base.decode16!()

    assert pk === Mcrypto.sk_to_pk(@signer, sk)
  end

  test "sign and verify" do
    sk =
      "D67C071B6F51D2B61180B9B1AA9BE0DD0704619F0E30453AB4A592B036EDE644E4852B7091317E3622068E62A5127D1FB0D4AE2FC50213295E10652D2F0ABFC7"
      |> Base.decode16!()

    pk = "E4852B7091317E3622068E62A5127D1FB0D4AE2FC50213295E10652D2F0ABFC7" |> Base.decode16!()

    message =
      "15D0014A9CF581EC068B67500683A2784A15E1F68057E5E37AAF3A0F58F3C43F083D6A5630130399D4E5003EA191FDE30849"
      |> Base.decode16!()

    signature =
      "321EE8262407BF091F16ED190A3074339EBDF956B3924A9CF29B86A366C9570C72C6A8D8363705182D5A99FAF152C617FD89D291C9D944F2A95DF57019303200"
      |> Base.decode16!()

    assert signature === Mcrypto.sign!(@signer, message, sk)
    assert Mcrypto.verify(@signer, message, signature, pk)
  end
end
