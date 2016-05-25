# Step 4: Add a decryption method

We are going to add another Swift method that encrypt a string with a secret.

1. Add a method definition to Objective-C class
  1. Open `CryptoProvider.m`
  2. Add the following code to the class
     ```c
     RCT_EXTERN_METHOD(
       decrypt:(NSString *) base64CipherText
       secret:(NSString *) secret
       callback:(RCTResponseSenderBlock *) callback
     )
     ```

2. Add a decryption method to Swift class
  1. Open `CryptoProvider.swift`
  2. Add the following code inside the class
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

3. Call the decryption method from JavaScript
  1. Open `index.ios.js`
  2. Modify `componentDidMount` with the following code
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
4. Verifying the result
  1. After running the code above, encrypting `Hello` then decrypting it should yield `Hello`