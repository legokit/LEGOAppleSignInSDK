//
//  LEGOAppleSignInUserInfo.h
//  LEGOAppleSignInSDK_Example
//
//  Created by 杨庆人 on 2019/10/15.
//  Copyright © 2019 564008993@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEGOAppleUserInfo : NSObject


@property (nonatomic, strong) id <ASAuthorizationCredential> credential API_AVAILABLE(ios(13.0));

/** [credential isKindOfClass:[ASAuthorizationAppleIDCredential class]] */

@property (nonatomic, copy, nullable) NSString *userId;   // An opaque user ID associated with the AppleID used for the sign in. This identifier will be stable across the 'developer team'

@property (nonatomic, strong, nullable) NSData *identityToken;   //  The ID token will contain the following information: Issuer Identifier, Subject Identifier, Audience, Expiry Time and Issuance Time signed by Apple's identity service.

@property (nonatomic, copy, nullable) NSString *email;    // An optional email shared by the user, maybe hidden by users

@property (nonatomic, strong, nullable) NSPersonNameComponents *fullName;  // An optional full name shared by the user.  This field is populated with a value that the user authorized.

/** [credential isKindOfClass:[ASPasswordCredential class]] */

@property (nonatomic, copy, nullable) NSString *userName;  // The user name of this credential

@property (nonatomic, copy, nullable) NSString *password;  // The password of this credential.

@end

NS_ASSUME_NONNULL_END
