# Step 4: Add a decrypt method

We are going to add another Swift method that decrypt a BASE64 binary with a secret.

1. Defines the decryption method in Objective-C
  1. We will define a `decrypt` method that consume a BASE64 text and a secret, decrypt it, and then returns the plain text asynchronously
  2. Add the following code to the file `CryptoProvider.m`
     ```objective-c
     RCT_EXTERN_METHOD(
       decrypt:(NSString *) base64CipherText
       secret:(NSString *) secret
       callback:(RCTResponseSenderBlock *) callback
     )
     ```

2. Implements the decryption method in Swift
  1. We will implement a `decrypt` method by using `CommonCrypto`
  2. Add the following code to the file `CryptoProvider.swift`
     ```swift
     @objc func decrypt(base64CipherText: String, secret: String, callback: RCTResponseSenderBlock) -> Void {
       guard !secret.isEmpty
         else { return callback(["must specify \"secret\""]) }

       guard let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)
         else { return callback(["\"secret\" is malformed"]) }

       guard let cipherTextData = NSData(base64EncodedString: base64CipherText, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
         else { return callback(["\"base64CipherText\" is malformed"]) }

       guard let plainTextData = NSMutableData(length: Int(cipherTextData.length) + kCCBlockSizeAES128)
         else { return callback(["cannot allocate memory for plain text"]) }

       var numBytesDecrypted: size_t = 0

       let cryptStatus = CCCrypt(
         UInt32(kCCDecrypt),
         UInt32(kCCAlgorithmAES128),
         UInt32(kCCOptionPKCS7Padding),
         UnsafePointer<UInt8>(secretData.bytes),
         size_t(kCCKeySizeAES128),
         nil,
         UnsafePointer<UInt8>(cipherTextData.bytes),
         size_t(cipherTextData.length),
         UnsafeMutablePointer<UInt8>(plainTextData.mutableBytes),
         size_t(plainTextData.length),
         &numBytesDecrypted
       );

       guard UInt32(cryptStatus) == UInt32(kCCSuccess)
         else { return callback(["decrypt failed"]) }

       plainTextData.length = numBytesDecrypted

       guard let plainText = NSString(data: plainTextData, encoding: NSUTF8StringEncoding)
         else { return callback(["cannot decrypt non-text"]) }

       return callback([
         NSNull(),
         plainText
       ])
     }
     ```

3. Consumes the `decrypt` method from JavaScript
  1. We will call our native `CryptoProvider` to encrypt `Hello` with secret `1234567890123456`, and then decrypt it immediately with the same secret
  2. Modify our `componentDidMount` with the following code, in `index.ios.js`

     ```js
     componentDidMount() {
       CryptoProvider.encrypt('Hello', '1234567890123456', (err, cipherText) => {
         if (err) {
           alert(`Failed to encrypt: ${err.message}`);
         } else {
           CryptoProvider.decrypt(cipherText, '1234567890123456', (err, plainText) => {
             if (err) {
               alert(`Failed to decrypt: ${err.message}`);
             } else {
               alert(`Plain text: ${plainText}`);
             }
           });
         }
       });
     }
     ```

4. Verifies the result
  1. After running the code above, encrypting `Hello` then decrypting it should yield `Hello`
