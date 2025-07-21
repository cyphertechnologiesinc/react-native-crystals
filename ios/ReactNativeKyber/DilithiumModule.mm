#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(Dilithium, NSObject)

RCT_EXTERN_METHOD(hello:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(generateKeyPair:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(sign:(NSString *)message
                  secretKeyBase64:(NSString *)secretKeyBase64
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(verify:(NSString *)message
                  signatureBase64:(NSString *)signatureBase64
                  publicKeyBase64:(NSString *)publicKeyBase64
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
