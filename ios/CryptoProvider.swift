//
//  CryptoProvider.swift
//  EncryptNatively
//
//  Created by William Wong on 24/5/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

import Foundation

@objc(CryptoProvider)
class CryptoProvider: NSObject {
  @objc func encrypt(key: String, plainText: String, callback: RCTResponseSenderBlock) -> Void {
    guard !key.isEmpty
      else { return callback(["must specify \"key\""]) }

    guard let keyData = key.dataUsingEncoding(NSUTF8StringEncoding)
      else { return callback(["\"key\" is malformed"]) }

    guard let plainTextData = plainText.dataUsingEncoding(NSUTF8StringEncoding)
      else { return callback(["\"plain text\" is malformed"]) }

    guard let cipherTextData = NSMutableData(length: Int(plainTextData.length) + kCCBlockSizeAES128)
      else { return callback(["cannot allocate memory for cipher text"]) }

    var numBytesEncrypted: size_t = 0

    let cryptStatus = CCCrypt(
      UInt32(kCCEncrypt),
      UInt32(kCCAlgorithmAES128),
      UInt32(kCCOptionPKCS7Padding),
      UnsafePointer<UInt8>(keyData.bytes),
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

  @objc func decrypt(key: String, cipherTextBase64: String, callback: RCTResponseSenderBlock) -> Void {
    guard !key.isEmpty
      else { return callback(["must specify \"key\""]) }

    guard let keyData = key.dataUsingEncoding(NSUTF8StringEncoding)
      else { return callback(["\"key\" is malformed"]) }

    guard let cipherTextData = NSData(base64EncodedString: cipherTextBase64, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
      else { return callback(["\"cipherTextBase64\" is malformed"]) }

    guard let plainTextData = NSMutableData(length: Int(cipherTextData.length) + kCCBlockSizeAES128)
      else { return callback(["cannot allocate memory for plain text"]) }

    var numBytesDecrypted: size_t = 0

    let cryptStatus = CCCrypt(
      UInt32(kCCDecrypt),
      UInt32(kCCAlgorithmAES128),
      UInt32(kCCOptionPKCS7Padding),
      UnsafePointer<UInt8>(keyData.bytes),
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
