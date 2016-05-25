# Step 1: Create a new Swift class

We are going to add a Swift class and make it visible to React Native.

1. Add a bridging header file
  1. Create a header file named `EncryptNatively-Bridging-Header.h`
  2. Add the following code
     ```c
     #import "RCTBridgeModule.h"
     ```

2. Add an Objective-C class to `extern`-alizing class
  1. Create an Objective-C file named `CryptoProvider.m`
  2. It should contains the following code
     ```c
     #import <Foundation/Foundation.h>
     #import "RCTBridgeModule.h"

     @interface RCT_EXTERN_MODULE(CryptoProvider, NSObject)

     @end
     ```

3. Add a Swift class
  1. Create a Swift file named `CryptoProvider.swift`
  2. It should contains the following code
     ```swift
     import Foundation

     @objc(CryptoProvider)
     class CryptoProvider: NSObject {
     }
     ```
