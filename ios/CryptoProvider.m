//
//  CryptoProvider.m
//  EncryptNatively
//
//  Created by William Wong on 27/5/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(CryptoProvider, NSObject)

RCT_EXTERN_METHOD(
  translateEnglishToHawaiian:(NSString *) english
  resolve:(RCTPromiseResolveBlock *) resolve
  reject:(RCTPromiseRejectBlock *) reject
)

@end