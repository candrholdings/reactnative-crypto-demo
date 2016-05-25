//
//  CryptoProvider.m
//  EncryptNatively
//
//  Created by William Wong on 25/5/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(CryptoProvider, NSObject)

RCT_EXTERN_METHOD(
  translateToHawaiian:(NSString *) english
  callback:(RCTResponseSenderBlock *) callack
)

RCT_EXTERN_METHOD(
  encrypt:(NSString *) plainText
  secret:(NSString *) secret
  callback:(RCTResponseSenderBlock *) callback
)

RCT_EXTERN_METHOD(
  decrypt:(NSString *) base64CipherText
  secret:(NSString *) secret
  callback:(RCTResponseSenderBlock *) callback
)

@end