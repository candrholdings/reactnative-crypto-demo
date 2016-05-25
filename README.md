# Step 2: Add a new Swift method

We are going to add a Swift method. The method will translate English into Hawaiian asynchronously.

1. Add a method definition to Objective-C class
  1. Open `CryptoProvider.m`, it holds all method definitions
  2. Add the following code to the class

     ```objective-c
     RCT_EXTERN_METHOD(
       TranslateToHawaiian:(NSString *) english
       callback:(RCTResponseSenderBlock *) callback
     )
     ```

2. Add a method to Swift class
  1. Open `CryptoProvider.swift`
  2. Add the following code inside the class

     ```swift
     @objc func translateToHawaiian(english: String, callback: RCTResponseSenderBlock) -> Void {
       if (english == "Hello") {
         callback([ NSNull(), "Aloha" ])
       } else {
         callback([ [ "message": "I don't know" ] ])
       }
     }
     ```

3. Call the Swift method from JavaScript
  1. Open `index.ios.js`
  2. Add the following code to the header of the file

     ```javascript
     import {
       CryptoProvider
     } from 'NativeModules';
     ```
  3. Add the following code to the React component

     ```javascript
     componentDidMount() {
       CryptoProvider.translateToHawaiian('Hello', (err, hawaiian) => {
         if (err) {
           alert(`Failed to translate: ${err.message}`);
         } else {
           alert(`In Hawaiian: ${hawaiian}`);
         }
       });
     }
     ```
