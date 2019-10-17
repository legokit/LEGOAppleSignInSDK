//
//  LEGOKeychainTool.m
//  LEGOAppleSignInSDK_Example
//
//  Created by 杨庆人 on 2019/10/17.
//  Copyright © 2019 564008993@qq.com. All rights reserved.
//

#import "LEGOKeychainTool.h"

@implementation LEGOKeychainTool

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,
            (__bridge_transfer id)kSecClass,service,
            (__bridge_transfer id)kSecAttrService,service,
            (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey {
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:sKey];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    NSData *data = nil;
    if (@available(iOS 11.0, *)) {
        data = [NSKeyedArchiver archivedDataWithRootObject:sValue requiringSecureCoding:NO error:nil];
    }
    else {
        data = [NSKeyedArchiver archivedDataWithRootObject:sValue];
    }
    [keychainQuery setObject:data forKey:(__bridge_transfer id)kSecValueData];

    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

+ (NSString *)readKeychainValue:(NSString *)sKey {
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:sKey];
        [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            if (@available(iOS 11.0, *)) {
                ret = (NSString *)[NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:(__bridge NSData *)keyData error:nil];
            } else {
                ret = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
                // Fallback on earlier versions
            }
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", sKey, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeychainValue:(NSString *)sKey {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:sKey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}


@end
