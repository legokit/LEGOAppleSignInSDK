#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LEGOAppleSignInManager.h"
#import "LEGOAppleSignInSDK.h"
#import "LEGOAppleUserInfo.h"
#import "LEGOKeychainTool.h"

FOUNDATION_EXPORT double LEGOAppleSignInSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char LEGOAppleSignInSDKVersionString[];

