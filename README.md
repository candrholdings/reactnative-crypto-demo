# Step 3: Add an encryption method

We are going to add another Swift method that encrypt a string with a secret.

1. Add a method definition to Objective-C class
  1. Open `CryptoProvider.m`
  2. Add the following code to the class
     ```c
     RCT_EXTERN_METHOD(
       encrypt:(NSString *) plainText
       secret:(NSString *) secret
       callback:(RCTResponseSenderBlock *) callback
     )
     ```

2. Add an encryption method to Swift class
  1. Open `CryptoProvider.swift`
  2. Add the following code inside the class
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
       );

       guard UInt32(cryptStatus) == UInt32(kCCSuccess)
         else { return callback(["encrypt failed"]) }

       cipherTextData.length = numBytesEncrypted

       callback([
         NSNull(),
         cipherTextData.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
       ])
     }
     ```

3. Call the encryption method from JavaScript
  1. Open `index.ios.js`
  2. Modify `componentDidMount` with the following code
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
4. Verifying the result
  1. After running the code above, encrypting `Hello` with secret `1234567890123456` should yield `+szA6t7l9kO128ylajHQ==` in BASE64