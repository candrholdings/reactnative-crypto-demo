//
//  CryptoProvider.swift
//  EncryptNatively
//
//  Created by William Wong on 25/5/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

import Foundation

@objc(CryptoProvider)
class CryptoProvider: NSObject {
  @objc func translateToHawaiian(
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
}