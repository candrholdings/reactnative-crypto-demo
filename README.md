# Step 4: Adds a decrypt method

We are going to add another Swift method that decrypt a BASE64 binary with a secret.

1. Defines the `decrypt` method in Objective-C
  1. We will define a `decrypt` method that consume a BASE64 text and a secret, decrypt it, and then returns the plaintext asynchronously
  2. Add the following code to the file `CryptoProvider.m`

    ```objective-c
    RCT_EXTERN_METHOD(
      decrypt:(NSString *) base64Ciphertext
      secret:(NSString *) secret
      resolve:(RCTPromiseResolveBlock) resolve
      reject:(RCTPromiseRejectBlock) reject
    )
    ```

2. Implements the `decrypt` method in Swift
  1. We will implement a `decrypt` method by using `CommonCrypto`
  2. Add the following code to the file `CryptoProvider.swift`

    ```swift
    @objc func decrypt(
      base64Ciphertext: String,
      secret: String,
      resolve: RCTPromiseResolveBlock,
      reject: RCTPromiseRejectBlock
    ) -> Void {
      guard !secret.isEmpty
        else { return reject("EINVAL", "must specify \"secret\"", nil) }

      guard let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)
        else { return reject("EINVAL", "\"secret\" is malformed", nil) }

      guard let ciphertextData = NSData(base64EncodedString: base64Ciphertext, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        else { return reject("EINVAL", "\"base64Ciphertext\" is malformed", nil) }

      guard let plaintextData = NSMutableData(length: Int(cipherTextData.length) + kCCBlockSizeAES128)
        else { return reject("ENOMEM", "cannot allocate memory for plaintext", nil) }

      var numBytesDecrypted: size_t = 0

      let cryptStatus = CCCrypt(
        UInt32(kCCDecrypt),
        UInt32(kCCAlgorithmAES128),
        UInt32(kCCOptionPKCS7Padding),
        UnsafePointer<UInt8>(secretData.bytes),
        size_t(kCCKeySizeAES128),
        nil,
        UnsafePointer<UInt8>(ciphertextData.bytes),
        size_t(ciphertextData.length),
        UnsafeMutablePointer<UInt8>(plaintextData.mutableBytes),
        size_t(plaintextData.length),
        &numBytesDecrypted
      )

      guard UInt32(cryptStatus) == UInt32(kCCSuccess)
        else { return reject("EFAIL", "decrypt failed", nil) }

      plaintextData.length = numBytesDecrypted

      guard let plaintext = NSString(data: plaintextData, encoding: NSUTF8StringEncoding)
        else { return reject("EFAIL", "cannot decrypt non-text", nil) }

      resolve(plaintext)
    }
    ```

3. Consumes the `decrypt` method from JavaScript
  1. We will call our native `CryptoProvider` to encrypt `Hello` with secret `1234567890123456`, and then decrypt it immediately with the same secret
  2. Modify our `componentDidMount` with the following code, in `index.ios.js`

    ```js
    componentDidMount() {
      CryptoProvider.encrypt('Hello', '1234567890123456')
        .then(
          ciphertext => {
            return CryptoProvider.decrypt(ciphertext, '1234567890123456');
          },
          err => {
            alert(`Failed to encrypt: ${err.message}`);
          }
        )
        .then(
          plaintext => {
            alert(`Plaintext: ${plaintext}`);
          },
          err => {
            alert(`Failed to decrypt: ${err.message}`);
          }
        )
        .done();
    }
    ```

4. Verifies the result
  1. After running the code above, encrypting `Hello` then decrypting it should yield `Hello`

Go to the [next step](https://github.com/candrholdings/reactnative-crypto-demo/tree/step-5).
