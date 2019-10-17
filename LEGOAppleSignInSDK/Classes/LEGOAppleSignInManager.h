//
//  LEGOAppleSignInManager.h
//  LEGOAppleSignInSDK_Example
//
//  Created by 杨庆人 on 2019/10/15.
//  Copyright © 2019 564008993@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEGOAppleUserInfo.h"

NS_ASSUME_NONNULL_BEGIN
NSString *const kAppleSignInUserIdentity;

typedef void(^LEGOAppleSignInSuccess)(LEGOAppleUserInfo *info);
typedef void(^LEGOAppleSignInFail)(NSError *error);
typedef void(^LEGOAppleSignInStatusChanged)(ASAuthorizationAppleIDProviderCredentialState credentialState) API_AVAILABLE(ios(13.0));

@interface LEGOAppleSignInManager : NSObject

/** Apple sign in status changed  */
@property (nonatomic, copy) LEGOAppleSignInStatusChanged signInStatusChangedBlock API_AVAILABLE(ios(13.0));

+ (instancetype)sharedInstance;

/** check Apple sign in status ,receive results by  'signInStatusChangedBlock'  */
- (void)checkAppleSignInState API_AVAILABLE(ios(13.0));

/** check Apple sign in status , this method can be used to get the current state of an opaque user ID previously given*/
- (void)checkAppleSignInStateCompletion:(LEGOAppleSignInStatusChanged)completion API_AVAILABLE(ios(13.0));

/** sign in with Apple  */
- (void)signInWithAppleByWindowAnchor:(ASPresentationAnchor)windowAnchor
                              success:(LEGOAppleSignInSuccess)success
                                 fail:(LEGOAppleSignInFail)fail API_AVAILABLE(ios(13.0));

/** perform Existing Account Setup Flows, prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.  */
- (void)performExistingAccountSetupFlows API_AVAILABLE(ios(13.0));

@end



NS_ASSUME_NONNULL_END


