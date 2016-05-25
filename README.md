# Step 2: Add a new Swift method

We are going to add a method in Swift. The method will translate English into Hawaiian asynchronously.

1. Add a method definition to the Objective-C class file
  1. Open `CryptoProvider.m`, it holds all method definitions
  2. Add the following code to the class

     ```objective-c
     RCT_EXTERN_METHOD(
       TranslateToHawaiian:(NSString *) english
       callback:(RCTResponseSenderBlock *) callback
     )
     ```

2. Add a method implementation to the Swift class file
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
     
  3. Currently, we only know how to translate "Hello" into "Aloha", otherwise, error will be thrown

3. Consume the Swift method in JavaScript
  1. Open `index.ios.js`
  2. To import the Swift method, we add the following code to the header of the file

     ```javascript
     import {
       CryptoProvider
     } from 'NativeModules';
     ```

  3. Then, we call the Swift method by adding the following code to the React component

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
