defmodule McryptoTest.AES do
  use ExUnit.Case
  alias Mcrypto.Crypter.AES

  test "encrypt with cbc256 should be able to decrypt" do
    crypter = %AES{mode: :aes_cbc256}
    plaintext = "hello world"
    key = "abcd1234"
    [iv: iv, ciphertext: ciphertext] = Mcrypto.encrypt(crypter, plaintext, key)
    assert plaintext === Mcrypto.decrypt(crypter, ciphertext, key, iv)
  end

  test "encrypt with encoder nil should be able to decrypt" do
    crypter = %AES{encoder: nil}
    plaintext = "hello world"
    key = "abcd1234"
    [iv: iv, ciphertext: ciphertext] = Mcrypto.encrypt(crypter, plaintext, key)
    assert plaintext === Mcrypto.decrypt(crypter, ciphertext, key, iv)
  end

  test "decrypt with wrong data should error" do
    crypter = %AES{}
    plaintext = "hello world"
    key = "abcd1234"
    [iv: iv, ciphertext: ciphertext] = Mcrypto.encrypt(crypter, plaintext, key)
    assert :error === Mcrypto.decrypt(crypter, ciphertext, "abcd12345", iv)
  end
end
