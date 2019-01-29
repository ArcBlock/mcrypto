defmodule McryptoTest.Keccak do
  use ExUnit.Case
  alias Mcrypto.Hasher.Keccak

  @message Base.decode16!("68656C6C6F")

  test "keccakf1600 hash should work as expected" do
    assert Mcrypto.hash(%Keccak{}, "") ===
             <<197, 210, 70, 1, 134, 247, 35, 60, 146, 126, 125, 178, 220, 199, 3, 192, 229, 0,
               182, 83, 202, 130, 39, 59, 123, 250, 216, 4, 93, 133, 164, 112>>

    assert Mcrypto.hash(%Keccak{}, @message) ===
             <<28, 138, 255, 149, 6, 133, 194, 237, 75, 195, 23, 79, 52, 114, 40, 123, 86, 217,
               81, 123, 156, 148, 129, 39, 49, 154, 9, 167, 163, 109, 234, 200>>

    assert Mcrypto.hash(%Keccak{size: 384}, @message) ===
             <<220, 239, 111, 183, 144, 143, 213, 43, 162, 106, 171, 167, 81, 33, 82, 106, 187,
               241, 33, 127, 28, 10, 49, 2, 70, 82, 209, 52, 211, 227, 47, 180, 205, 142, 156,
               112, 59, 143, 67, 231, 39, 123, 89, 165, 205, 64, 33, 117>>
  end
end
