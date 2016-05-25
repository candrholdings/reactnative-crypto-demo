# Step 3: Adds an encrypt method

We are going to add another Swift method that encrypt a string with a secret, using AES128 in `CommonCrypto` from `Security.framework`.

1. Prepares our project to use `CommonCrypto` from `Security.framework`
  1. Open project settings
    1. In the "Linked Frameworks and Libraries" section, find and add `Security.framework` reference
  3. In `EncryptNatively-Bridging-Header.h`
    1. Add the following code so that every classes in the project can consume the `CommonCrypto` library
    
      ```objective-c
      #import <CommonCrypto/CommonCrypto.h>
      ```

2. Defines the encrypt method in Objective-C
  1. We will define an `encrypt` method that consume a plain text and a secret, encrypt it, and then returns the cipher text in BASE64 asynchronously
  2. Add the following to the file `CryptoProvider.m`

    ```objective-c
    RCT_EXTERN_METHOD(
      encrypt:(NSString *) plainText
      secret:(NSString *) secret
      callback:(RCTResponseSenderBlock *) callback
    )
    ```

3. Implements the encrypt method in Swift
  1. We will implement an `encrypt` method by using `CommonCrypto`
  2. Since cipher text is in binary, it is not supported by React Native, we will return it as BASE64 text
    1. List of supported types can be found at http://facebook.github.io/react-native/docs/native-modules-ios.html#argument-types
  3. Add the following code to the file `CryptoProvider.swift`

    ```swift
    @objc func encrypt(
      plainText: String,
      secret: String,
      callback: RCTResponseSenderBlock
    ) -> Void {
      guard !secret.isEmpty
        else { return callback(["must specify \"secret\""]) }

      guard let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)
        else { return callback(["\"secret\" is malformed"]) }

      guard let plainTextData = plainText.dataUsingEncoding(NSUTF8StringEncoding)
        else { return callback(["\"plain text\" is malformed"]) }

      guard let cipherTextData = NSMutableData(length: Int(plainTextData.length) + kCCBlockSizeAES128)
        else { return callback(["cannot allocate memory for cipher text"]) }

      var numBytesEncrypted: size_t = 0

      let cryptStatus = CCCrypt(
        UInt32(kCCEncrypt),
        UInt32(kCCAlgorithmAES128),
        UInt32(kCCOptionPKCS7Padding),
        UnsafePointer<UInt8>(secretData.bytes),
        size_t(kCCKeySizeAES128),
        nil,
        UnsafePointer<UInt8>(plainTextData.bytes),
        size_t(plainTextData.length),
        UnsafeMutablePointer<UInt8>(cipherTextData.mutableBytes),
        size_t(cipherTextData.length),
        &numBytesEncrypted
      )

      guard UInt32(cryptStatus) == UInt32(kCCSuccess)
        else { return callback(["encrypt failed"]) }

      cipherTextData.length = numBytesEncrypted

      callback([
        NSNull(),
        cipherTextData.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
      ])
    }
    ```

4. Calls the `encrypt` method from JavaScript
  1. We will call our native `CryptoProvider` to encrypt `Hello` with secret `1234567890123456`
    1. Note that the secret must be 16 characters long (128-bit), otherwise, it will be truncated or pad with random characters
  2. Modify our `componentDidMount` with the following code, in `index.ios.js`

    ```javascript
    componentDidMount() {
      CryptoProvider.encrypt('Hello', '1234567890123456', (err, cipherText) => {
        if (err) {
          alert(`Failed to encrypt: ${err.message}`);
        } else {
          alert(`Encrypted: ${cipherText}`);
        }
      });
    }
    ```

5. Verifies the result
  1. After running the code above, encrypting `Hello` with secret `1234567890123456` should yield `+szA6t7l9kO128ylajHQ==` in BASE64
