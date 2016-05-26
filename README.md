# Step 2: Creates a new Swift class

## Objectives

We are going to add a Swift class and make it visible to React Native.

## Steps to achieve

1. Adds an Objective-C class to `extern`-alizing class
  1. Creates an Objective-C file named `CryptoProvider.m`, it will inherit `NSObject`
  2. Adds the following code

     ```objective-c
     #import <Foundation/Foundation.h>
     #import "RCTBridgeModule.h"

     @interface RCT_EXTERN_MODULE(CryptoProvider, NSObject)
     @end
     ```

2. Adds a Swift class
  1. Creates a Swift file named `CryptoProvider.swift`, it should be on parity with Objective-C file and inherit `NSObject`
  2. It should contains the following code

     ```swift
     import Foundation

     @objc(CryptoProvider)
     class CryptoProvider: NSObject {
     }
     ```

3. Adds a header file to bridging between Objective-C and Swift
  1. Creates a header file named `EncryptNatively-Bridging-Header.h`
    1. Xcode may prompt to create the bridging header file for you
  2. Adds the following code to enable React Native Modules bridge

     ```objective-c
     #import "RCTBridgeModule.h"
     ```

## What's next

Go to the [next step](https://github.com/candrholdings/reactnative-crypto-demo/tree/step-3).
