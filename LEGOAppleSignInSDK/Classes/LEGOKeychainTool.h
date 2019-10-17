//
//  LEGOKeychainTool.h
//  LEGOAppleSignInSDK_Example
//
//  Created by 杨庆人 on 2019/10/17.
//  Copyright © 2019 564008993@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEGOKeychainTool : NSObject

/**
 *  储存字符串到钥匙串 🔑  Save string to Keychain
 *
 *  @param sValue Value
 *  @param sKey  Key
 */
+ (void)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey;


/**
 *  从钥匙串🔑获取字符串 Get string from Keychain
 *
 *  @param sKey Key
 *  @return Value
 */
+ (NSString *)readKeychainValue:(NSString *)sKey;


/**
 *  从钥匙串🔑删除字符串 Delete string from Keychain
 *
 *  @param sKey 对应的Key
 */
+ (void)deleteKeychainValue:(NSString *)sKey;

@end

NS_ASSUME_NONNULL_END
