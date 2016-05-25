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
  @objc func translateToHawaiian(english: String, callback: RCTResponseSenderBlock) -> Void {
    if (english == "Hello") {
      callback([ NSNull(), "Aloha" ])
    } else {
      callback([ [ "message": "I don't know" ] ])
    }
  }
}