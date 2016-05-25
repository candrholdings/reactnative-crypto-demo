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

  @objc func encrypt(
    plainText: String,
    secret: String,
    callback: RCTResponseSenderBlock
  ) -> Void {
    guard !secret.isEmpty
      else { return callback(["must specify \"secret\""]) }

    guard let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)
      else { return callback(["\"secret\" is malformed"]) }

    guard let plainTextData = plainText.dataUsingEncoding(NSUTF8StringEncoding)
      else { return callback(["\"plain text\" is malformed"]) }

    guard let cipherTextData = NSMutableData(length: Int(plainTextData.length) + kCCBlockSizeAES128)
      else { return callback(["cannot allocate memory for cipher text"]) }

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
    );

    guard UInt32(cryptStatus) == UInt32(kCCSuccess)
      else { return callback(["encrypt failed"]) }

    cipherTextData.length = numBytesEncrypted

    callback([
      NSNull(),
      cipherTextData.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
    ])
  }
  
  @objc func decrypt(base64CipherText: String, secret: String, callback: RCTResponseSenderBlock) -> Void {
    guard !secret.isEmpty
      else { return callback(["must specify \"secret\""]) }

    guard let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)
      else { return callback(["\"secret\" is malformed"]) }

    guard let cipherTextData = NSData(base64EncodedString: base64CipherText, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
      else { return callback(["\"base64CipherText\" is malformed"]) }

    guard let plainTextData = NSMutableData(length: Int(cipherTextData.length) + kCCBlockSizeAES128)
      else { return callback(["cannot allocate memory for plain text"]) }

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
    );

    guard UInt32(cryptStatus) == UInt32(kCCSuccess)
      else { return callback(["decrypt failed"]) }

    plainTextData.length = numBytesDecrypted

    guard let plainText = NSString(data: plainTextData, encoding: NSUTF8StringEncoding)
      else { return callback(["cannot decrypt non-text"]) }

    return callback([
      NSNull(),
      plainText
    ])
  }
}