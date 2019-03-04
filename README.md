# Mcrypto

Multiple crypto functionalities support.

## Hash

Hash functions support:

- SHA2
- SHA3 (the NIST SHA3 winner keccak)
- Keccakf1600 (the original keccak before NIST SHA3)
- Blake2b

For each type, it supports:

- `size`: the output size of the hash function
- `round`: rounds of hash

Refer to `lib/mcrypto/hasher/#{type}.ex` for default values.

```
iex(1)> Mcrypto.Hasher.hash(%Mcrypto.Hasher.Sha2{}, "123")
<<90, 119, 209, 233, 97, 45, 53, 11, 55, 52, 246, 40, 34, 89, 183, 255, 10, 63,
  135, 214, 44, 254, 245, 243, 94, 145, 165, 96, 76, 4, 144, 163>>
iex(2)> Mcrypto.Hasher.hash(%Mcrypto.Hasher.Sha3{}, "123")
<<160, 58, 177, 155, 134, 111, 197, 133, 181, 203, 24, 18, 162, 246, 60, 168,
  97, 231, 231, 100, 62, 229, 212, 63, 215, 16, 107, 98, 55, 37, 253, 103>>
iex(3)> Mcrypto.Hasher.hash(%Mcrypto.Hasher.Keccak{}, "123")
<<100, 230, 4, 120, 124, 191, 25, 72, 65, 231, 182, 141, 124, 210, 135, 134,
  246, 201, 160, 163, 171, 159, 139, 10, 14, 135, 203, 67, 135, 171, 1, 7>>
iex(4)> Mcrypto.Hasher.hash(%Mcrypto.Hasher.Blake2b{}, "123")
<<245, 214, 123, 174, 115, 176, 225, 13, 13, 253, 48, 67, 179, 244, 241, 0, 173,
  160, 20, 197, 195, 123, 213, 206, 151, 129, 59, 19, 245, 171, 43, 207>>
iex(5)> Mcrypto.Hasher.hash(%Mcrypto.Hasher.Sha3{round: 2}, "123")
<<178, 166, 47, 187, 14, 183, 128, 107, 24, 76, 153, 89, 4, 151, 121, 57, 83,
  110, 61, 68, 212, 129, 77, 183, 155, 89, 119, 84, 133, 8, 147, 108>>
```

## Signer

Signer functions support:

- Ed25519
- secp256k1

```
iex(1)> {pk, sk} = Mcrypto.Signer.keypair(%Mcrypto.Signer.Ed25519{})
{<<232, 40, 152, 168, 166, 80, 64, 142, 82, 105, 2, 147, 80, 38, 228, 179, 50,
   188, 2, 216, 53, 205, 99, 1, 189, 206, 7, 223, 18, 197, 78, 254>>,
 <<24, 50, 129, 21, 98, 11, 117, 213, 137, 137, 26, 145, 99, 21, 50, 37, 125,
   147, 12, 81, 33, 233, 58, 17, 13, 125, 86, 77, 199, 116, 104, 222, 232, 40,
   152, 168, 166, 80, 64, 142, 82, 105, 2, 147, 80, 38, 228, 179, ...>>}
iex(2)> sig = Mcrypto.Signer.sign!(%Mcrypto.Signer.Ed25519{}, "123", sk)
<<19, 145, 10, 186, 226, 92, 99, 83, 14, 41, 144, 63, 68, 161, 107, 184, 186,
  181, 252, 248, 246, 236, 170, 64, 199, 163, 175, 197, 113, 217, 6, 211, 113,
  64, 251, 180, 253, 147, 106, 31, 51, 244, 184, 74, 182, 49, 13, 170, 174, 164,
  ...>>
iex(3)> Mcrypto.Signer.verify(%Mcrypto.Signer.Ed25519{}, "123", sig, pk)
true
```

## Crypter

Crypter functions support:

- AES CBC 256 mode

For each type, it supports:

- `encoder`: `:base64` or `nil`. The encoding method for the result.

```
iex(1)> [iv: iv, ciphertext: ct] = Mcrypto.Crypter.encrypt(%Mcrypto.Crypter.AES{}, "123", "password")
[iv: "MQgRmTS8JIzX3EP1u2PEqQ==", ciphertext: "HsX6fxHqRUvLNueihOorUA=="]
iex(2)> Mcrypto.Crypter.decrypt(%Mcrypto.Crypter.AES{}, ct, "password", iv)
"123"
iex(3)> [iv: iv, ciphertext: ct] = Mcrypto.Crypter.encrypt(%Mcrypto.Crypter.AES{encoder: nil}, "123", "password")
[
  iv: <<136, 31, 159, 34, 254, 185, 17, 13, 53, 92, 89, 51, 254, 86, 196, 112>>,
  ciphertext: <<114, 43, 113, 13, 227, 87, 156, 126, 55, 101, 126, 236, 146,
    229, 75, 67>>
]
iex(4)> Mcrypto.Crypter.decrypt(%Mcrypto.Crypter.AES{encoder: nil}, ct, "password", iv)
"123"
```
