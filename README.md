# Step 3: Adds a new Swift method

## Objectives

We are going to add a simple method in Swift. This method will translate English into Hawaiian asynchronously. The method will be consumed in JavaScript.

## Steps to achieve

1. Defines the translate method in Objective-C
  1. We will define the `translateEnglishToHawaiian` method, it accept English string and translate to Hawaiian asynchronously
  2. Add the following code to the file `CryptoProvider.m`

    ```objective-c
    RCT_EXTERN_METHOD(
      translateEnglishToHawaiian:(NSString *) english
      resolve:(RCTPromiseResolveBlock *) resolve
      reject:(RCTPromiseRejectBlock *) reject
    )
    ```

2. Implements the method in Swift
  1. We will implement the `translateEnglishToHawaiian` method, currently, it only understand "Hello" in English and translate to "Aloha" in Hawaiian
  2. Add the following code to the file `CryptoProvider.swift`

    ```swift
    @objc func translateEnglishToHawaiian(
      english: String,
      resolve: RCTPromiseResolveBlock,
      reject: RCTPromiseRejectBlock
    ) -> Void {
      if (english == "Hello") {
        resolve("Aloha")
      } else {
        reject("ENOENT", "I don't know", nil)
      }
    }
    ```

  3. Currently, we only know how to translate "Hello" into "Aloha", otherwise, error will be thrown

3. Consumes the `translateEnglishToHawaiian` method in JavaScript, in `index.ios.js`
  1. Imports the Swift `CryptoProvider` class

    ```javascript
    import {
      CryptoProvider
    } from 'NativeModules';
    ```

  2. Adds a `_translate` function to run the translation natively
    1. The function asks for the english text because `this.state` does not support dirty read
    3. The result text will be shown in the ciphertext textbox

    ```javascript
    _translate(english) {
      CryptoProvider.translateEnglishToHawaiian(english)
        .then(
          hawaiian => this.setState({ ciphertext: hawaiian }),
          err => alert(`Failed to translate due to "${err.message}"`)
        ).done();
    }
    ```

  3. Calls the `_translate` function as soon as the component is initialized

    ```javascript
    componentWillMount() {
      this._translate(this.state.inputString);
    }
    ```

  4. Calls the `_translate` function as soon as the input string has changed
    1. We will modify the existing `onInputStringChange` function

      ```javascript
      onInputStringChange(inputString) {
        this.setState({ inputString });
        this._translate(inputString);
      }
      ```

## What's next

Go to the [next step](https://github.com/candrholdings/reactnative-crypto-demo/tree/step-4).