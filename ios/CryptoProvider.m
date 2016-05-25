//
//  CryptoProvider.m
//  EncryptNatively
//
//  Created by William Wong on 24/5/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(CryptoProvider, NSObject)

RCT_EXTERN_METHOD(
  encrypt:(NSString *)key
  plainText:(NSString *)plainText
  callback:(RCTResponseSenderBlock *)callback
)

RCT_EXTERN_METHOD(
  decrypt:(NSString *)key
  cipherTextBase64:(NSString *)cipherTextBase64
  callback:(RCTResponseSenderBlock *)callback
)

@end