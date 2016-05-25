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
  resolve:(RCTPromiseResolveBlock) resolve
  reject:(RCTPromiseRejectBlock) reject
)

RCT_EXTERN_METHOD(
  encrypt:(NSString *) plaintext
  secret:(NSString *) secret
  resolve:(RCTPromiseResolveBlock) resolve
  reject:(RCTPromiseRejectBlock) reject
)

@end