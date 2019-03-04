defmodule McryptoTest.Sha3 do
  use ExUnit.Case
  alias Mcrypto.Hasher.Sha3

  @message Base.decode16!("68656C6C6F")

  test "sha3 hash shall work as expected" do
    assert Mcrypto.hash(%Sha3{}, "") ===
             <<167, 255, 198, 248, 191, 30, 215, 102, 81, 193, 71, 86, 160, 97, 214, 98, 245, 128,
               255, 77, 228, 59, 73, 250, 130, 216, 10, 75, 128, 248, 67, 74>>

    assert Mcrypto.hash(%Sha3{}, @message) ===
             <<51, 56, 190, 105, 79, 80, 197, 243, 56, 129, 73, 134, 205, 240, 104, 100, 83, 168,
               136, 184, 79, 66, 77, 121, 42, 244, 185, 32, 35, 152, 243, 146>>

    assert Mcrypto.hash(%Sha3{size: 384}, @message) ===
             <<114, 10, 234, 17, 1, 158, 240, 100, 64, 251, 240, 93, 135, 170, 36, 104, 10, 33,
               83, 223, 57, 7, 178, 54, 49, 231, 23, 124, 230, 32, 250, 19, 48, 255, 7, 192, 253,
               222, 229, 70, 153, 164, 195, 238, 14, 233, 216, 135>>
  end

  test "sha3 hash shall work with large data" do
    data = String.duplicate("x", 2_000_000)

    assert Mcrypto.hash(%Sha3{}, data) ===
             <<224, 237, 251, 95, 119, 8, 220, 204, 28, 189, 195, 121, 136, 89, 153, 106, 53, 20,
               51, 50, 63, 244, 194, 50, 57, 250, 41, 82, 18, 214, 30, 24>>
  end
end
