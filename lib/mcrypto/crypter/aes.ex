defmodule Mcrypto.Crypter.AES do
  @moduledoc """
  AES encryption. Right now we just support cbc256.
  """

  use TypedStruct

  @typedoc """
  AES crypter data structure contains the following keys:

  * `:name`: crypter name
  * `:mode`: crypter mode. Currently only support cbc256.
  * `:encoder`: encoding method. base64 or binary.
  """
  typedstruct do
    field(:name, atom(), default: :aes)
    field(:mode, atom(), default: :aes_cbc256)
    field(:encoder, atom(), default: :base64)
  end
end

defimpl Mcrypto.Crypter, for: Mcrypto.Crypter.AES do
  @moduledoc """
  This implementation is inspired by: https://github.com/izelnakri/aes256
  """
  alias Mcrypto.Hasher.Sha2

  def encrypt(crypter, plaintext, key), do: do_encrypt(crypter, plaintext, key)

  def decrypt(crypter, ciphertext, key, iv), do: do_decrypt(crypter, ciphertext, key, iv)

  # private functions
  defp do_encrypt(crypter, plaintext, password) do
    iv = :crypto.strong_rand_bytes(16)
    key = Mcrypto.hash(%Sha2{}, password)
    result = :crypto.block_encrypt(crypter.mode, key, iv, pkcs7_pad(plaintext))

    {encoded_iv, ciphertext} =
      case crypter.encoder do
        :base64 -> {Base.encode64(iv), Base.encode64(result)}
        _ -> {iv, result}
      end

    [iv: encoded_iv, ciphertext: ciphertext]
  end

  defp do_decrypt(crypter, ciphertext, password, iv) do
    key = Mcrypto.hash(%Sha2{}, password)

    {decoded_iv, target} =
      case crypter.encoder do
        :base64 -> {Base.decode64!(iv), Base.decode64!(ciphertext)}
        _ -> {iv, ciphertext}
      end

    padded = :crypto.block_decrypt(crypter.mode, key, decoded_iv, target)

    case pkcs7_unpad(padded) do
      {:ok, plaintext} -> plaintext
      result -> result
    end
  end

  # Pads a message using the PKCS #7 cryptographic message syntax.
  #
  # See: https://tools.ietf.org/html/rfc2315
  # See: `pkcs7_unpad/1`
  defp pkcs7_pad(message) do
    bytes_remaining = rem(byte_size(message), 16)
    padding_size = 16 - bytes_remaining
    message <> :binary.copy(<<padding_size>>, padding_size)
  end

  # Unpads a message using the PKCS #7 cryptographic message syntax.
  #
  # See: https://tools.ietf.org/html/rfc2315
  # See: `pkcs7_pad/1`
  defp pkcs7_unpad(<<>>), do: :error

  defp pkcs7_unpad(message) do
    padding_size = :binary.last(message)

    if padding_size <= 16 do
      message_size = byte_size(message)

      if binary_part(message, message_size, -padding_size) ===
           :binary.copy(<<padding_size>>, padding_size) do
        {:ok, binary_part(message, 0, message_size - padding_size)}
      else
        :error
      end
    else
      :error
    end
  end
end
