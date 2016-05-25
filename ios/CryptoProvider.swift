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
    plainText: String,
    secret: String,
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) -> Void {
    guard !secret.isEmpty
      else { return reject("EINVAL", "must specify \"secret\"", nil) }

    guard let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)
      else { return reject("EINVAL", "\"secret\" is malformed", nil) }

    guard let plainTextData = plainText.dataUsingEncoding(NSUTF8StringEncoding)
      else { return reject("EINVAL", "\"plain text\" is malformed", nil) }

    guard let cipherTextData = NSMutableData(length: Int(plainTextData.length) + kCCBlockSizeAES128)
      else { return reject("ENOMEM", "cannot allocate memory for cipher text", nil) }

    var numBytesEncrypted: size_t = 0

    let cryptStatus = CCCrypt(
      UInt32(kCCEncrypt),
      UInt32(kCCAlgorithmAES128),
      UInt32(kCCOptionPKCS7Padding),
      UnsafePointer<UInt8>(secretData.bytes),
      size_t(kCCKeySizeAES128),
      nil,
      UnsafePointer<UInt8>(plainTextData.bytes),
      size_t(plainTextData.length),
      UnsafeMutablePointer<UInt8>(cipherTextData.mutableBytes),
      size_t(cipherTextData.length),
      &numBytesEncrypted
    )

    guard UInt32(cryptStatus) == UInt32(kCCSuccess)
      else { return reject("EFAIL", "encrypt failed", nil) }

    cipherTextData.length = numBytesEncrypted

    resolve(cipherTextData.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed))
  }

  @objc func decrypt(
    base64CipherText: String,
    secret: String,
    resolve: RCTPromiseResolveBlock,
    reject: RCTPromiseRejectBlock
  ) -> Void {
    guard !secret.isEmpty
      else { return reject("EINVAL", "must specify \"secret\"", nil) }

    guard let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)
      else { return reject("EINVAL", "\"secret\" is malformed", nil) }

    guard let cipherTextData = NSData(base64EncodedString: base64CipherText, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
      else { return reject("EINVAL", "\"base64CipherText\" is malformed", nil) }

    guard let plainTextData = NSMutableData(length: Int(cipherTextData.length) + kCCBlockSizeAES128)
      else { return reject("ENOMEM", "cannot allocate memory for plain text", nil) }

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
    )

    guard UInt32(cryptStatus) == UInt32(kCCSuccess)
      else { return reject("EFAIL", "decrypt failed", nil) }

    plainTextData.length = numBytesDecrypted

    guard let plainText = NSString(data: plainTextData, encoding: NSUTF8StringEncoding)
      else { return reject("EFAIL", "cannot decrypt non-text", nil) }

    return resolve(plainText)
  }
}