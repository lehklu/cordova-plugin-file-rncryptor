#import <Foundation/Foundation.h>
#import <Security/SecRandom.h>
#import <Cordova/CDV.h>
#ifndef __CORDOVA_4_0_0
#import <Cordova/NSData+Base64.h>
#endif
#import "RNEncryptor.h"
#import "RNDecryptor.h"


@interface FileRNCryptor : CDVPlugin {
}

- (void)encrypt:(CDVInvokedUrlCommand*)command;
- (void)decrypt:(CDVInvokedUrlCommand*)command;
- (NSString*)crypto:(NSString*)action command:(CDVInvokedUrlCommand*)command;
- (void)encryptText:(CDVInvokedUrlCommand*)command;
- (void)decryptText:(CDVInvokedUrlCommand*)command;
- (NSString*)cryptoText:(NSString*)action command:(CDVInvokedUrlCommand*)command;
@end
