# Step 2: Adds a new Swift method

We are going to add a method in Swift. The method will translate English into Hawaiian asynchronously.

1. Defines the translate method in Objective-C
  1. We will define the `translateToHawaiian` method, it accept English string and translate to Hawaiian asynchronously
  2. Add the following code to the file `CryptoProvider.m`

     ```objective-c
     RCT_EXTERN_METHOD(
       translateToHawaiian:(NSString *) english
       callback:(RCTResponseSenderBlock *) callback
     )
     ```

2. Implements the method in Swift
  1. We will implement the `translateToHawaiian` method, currently, it only understand "Hello" in English and translate to "Aloha" in Hawaiian
  2. Add the following code to the file `CryptoProvider.swift`

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

3. Consumes the `translateToHawaiian` method in JavaScript
  1. We will call the `translateToHawaiian` method when the UI is ready, and then output the result in an alert box
  2. Imports the Swift method by adding the following code to `index.ios.js`

     ```javascript
     import {
       CryptoProvider
     } from 'NativeModules';
     ```

  3. Calls the Swift method asynchronously by adding the following code to the React component in `index.ios.js`

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
