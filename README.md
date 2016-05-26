# Step 3: Adds an encrypt method

## Objectives

We are going to add another Swift method that encrypt a string with a secret, using AES128 in [`CommonCrypto`](https://developer.apple.com/cryptography/) from `Security.framework`. The method will be consumed in JavaScript, replacing the translation introduced in last step.

## Steps to achieve

1. Prepares our project to use `CommonCrypto` from `Security.framework`
  1. In Xcode, open project settings
    1. In the "Linked Frameworks and Libraries" section, find and add `Security.framework` reference
  2. In `EncryptNatively-Bridging-Header.h`
    1. Add the following code so that every classes in the project can consume the `CommonCrypto` library

      ```objective-c
      #import <CommonCrypto/CommonCrypto.h>
      ```

2. Defines the `encrypt` method in Objective-C
  1. We will define an `encrypt` method that consume a plaintext and a secret, encrypt it, and then returns the ciphertext in BASE64 asynchronously
  2. Add the following to the file `CryptoProvider.m`

    ```objective-c
    RCT_EXTERN_METHOD(
      encrypt:(NSString *) plaintext
      secret:(NSString *) secret
      resolve:(RCTPromiseResolveBlock) resolve
      reject:(RCTPromiseRejectBlock) reject
    )
    ```

3. Implements the `encrypt` method in Swift
  1. We will implement an `encrypt` method by using `CommonCrypto`
  2. Since ciphertext is in binary, it is not supported by React Native, we will return it as BASE64 text
    1. List of supported types can be found at http://facebook.github.io/react-native/docs/native-modules-ios.html#argument-types
  3. We are using secret as encoded in UTF-8, and it lowered the entropy of the system. We recommend using binary secret generated by RNG in production system
  4. Add the following code to the file `CryptoProvider.swift`

    ```swift
    @objc func encrypt(
      plaintext: String,
      secret: String,
      resolve: RCTPromiseResolveBlock,
      reject: RCTPromiseRejectBlock
    ) -> Void {
      guard !secret.isEmpty
        else { return reject("EINVAL", "must specify \"secret\"", nil) }

      guard let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)
        else { return reject("EINVAL", "\"secret\" is malformed", nil) }

      guard let plaintextData = plaintext.dataUsingEncoding(NSUTF8StringEncoding)
        else { return reject("EINVAL", "\"plaintext\" is malformed", nil) }

      guard let ciphertextData = NSMutableData(length: Int(plaintextData.length) + kCCBlockSizeAES128)
        else { return reject("ENOMEM", "cannot allocate memory for ciphertext", nil) }

      var numBytesEncrypted: size_t = 0

      let cryptStatus = CCCrypt(
        UInt32(kCCEncrypt),
        UInt32(kCCAlgorithmAES128),
        UInt32(kCCOptionPKCS7Padding),
        UnsafePointer<UInt8>(secretData.bytes),
        size_t(kCCKeySizeAES128),
        nil,
        UnsafePointer<UInt8>(plaintextData.bytes),
        size_t(plaintextData.length),
        UnsafeMutablePointer<UInt8>(ciphertextData.mutableBytes),
        size_t(ciphertextData.length),
        &numBytesEncrypted
      )

      guard UInt32(cryptStatus) == UInt32(kCCSuccess)
        else { return reject("EFAIL", "encrypt failed", nil) }

      ciphertextData.length = numBytesEncrypted

      resolve(ciphertextData.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed))
    }
    ```

4. Calls the `encrypt` method from JavaScript, in `index.ios.js`
  1. We will call our native `CryptoProvider` to encrypt `Hello` with secret `1234567890123456`
    1. Note that the secret must be 16 characters long (128-bit), otherwise, it will be truncated or pad with random characters
  2. Adds a new `_encrypt` function

    ```javascript
    _encrypt(inputString, secret) {
      CryptoProvider.encrypt(inputString, secret)
        .then(
          ciphertext => this.setState({ ciphertext }),
          err => alert(`Failed to encrypt due to "${err.message}"`)
        )
        .done();
    }
    ```

  3. Replaces the `_translate` function with `_encrypt` function
    1. Replaces in `componentWillMount` function

      ```javascript
      componentWillMount() {
        this._encrypt(this.state.inputString, this.state.secret);
      }
      ```

    2. Replaces in `onInputStringChange` function

      ```javascript
      onInputStringChange(inputString) {
        this.setState({ inputString });
        this._encrypt(inputString, this.state.secret);
      }
      ```

    3. Adds to `onSecretChange` function

      ```javascript
      onSecretChange(secret) {
        this.setState({ secret });
        this._encrypt(this.state.inputString, secret);
      }
      ```

5. Verifies the result
  1. After running the code above, encrypting `Hello` with secret `1234567890123456` should yield `+szA6t7l9kO128ylajHQ==` in BASE64

## What's next

Go to the [next step](https://github.com/candrholdings/reactnative-crypto-demo/tree/step-4).