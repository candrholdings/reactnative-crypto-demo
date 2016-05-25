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

  @objc func encrypt(
    plaintext: String,
    secret: String,
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) -> Void {
    guard !secret.isEmpty
      else { return reject("EINVAL", "must specify \"secret\"", nil) }

    guard let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)
      else { return reject("EINVAL", "\"secret\" is malformed", nil) }

    guard let plaintextData = plaintext.dataUsingEncoding(NSUTF8StringEncoding)
      else { return reject("EINVAL", "\"plaintext\" is malformed", nil) }

    guard let ciphertextData = NSMutableData(length: Int(plaintextData.length) + kCCBlockSizeAES128)
      else { return reject("ENOMEM", "cannot allocate memory for ciphertext", nil) }

    var numBytesEncrypted: size_t = 0

    let cryptStatus = CCCrypt(
      UInt32(kCCEncrypt),
      UInt32(kCCAlgorithmAES128),
      UInt32(kCCOptionPKCS7Padding),
      UnsafePointer<UInt8>(secretData.bytes),
      size_t(kCCKeySizeAES128),
      nil,
      UnsafePointer<UInt8>(plaintextData.bytes),
      size_t(plaintextData.length),
      UnsafeMutablePointer<UInt8>(ciphertextData.mutableBytes),
      size_t(ciphertextData.length),
      &numBytesEncrypted
    )

    guard UInt32(cryptStatus) == UInt32(kCCSuccess)
      else { return reject("EFAIL", "encrypt failed", nil) }

    ciphertextData.length = numBytesEncrypted

    resolve(ciphertextData.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed))
  }
}