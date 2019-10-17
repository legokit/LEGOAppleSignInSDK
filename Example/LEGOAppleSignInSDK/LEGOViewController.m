//
//  LEGOViewController.m
//  LEGOAppleSignInSDK
//
//  Created by 564008993@qq.com on 10/15/2019.
//  Copyright (c) 2019 564008993@qq.com. All rights reserved.
//

#import "LEGOViewController.h"
#import <Masonry/Masonry.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import <LEGOAppleSignInSDK/LEGOAppleSignInSDK.h>

@interface LEGOViewController ()

@end

@implementation LEGOViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkButtonAction:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *signInButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleBlack];
        [signInButton addTarget:self action:@selector(signInWithApple:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:signInButton];
        
        [signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(185, 45));
        }];
    } else {
        // Fallback on earlier versions
    }
    

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)signInWithApple:(id)sender {
    if (@available(iOS 13.0, *)) {
        [[LEGOAppleSignInManager sharedInstance] signInWithAppleByWindowAnchor:self.view.window success:^(LEGOAppleUserInfo * _Nonnull info) {
            // sign in sucess...
        } fail:^(NSError * _Nonnull error) {
            // sign in fail...
            NSString *errorMsg = nil;
            switch (error.code) {
                case ASAuthorizationErrorCanceled:
                    errorMsg = @"User cancelled authorization request";
                    break;
                case ASAuthorizationErrorFailed:
                    errorMsg = @"Authorization request failed";
                    break;
                case ASAuthorizationErrorInvalidResponse:
                    errorMsg = @"Invalid authorization request response";
                    break;
                case ASAuthorizationErrorNotHandled:
                    errorMsg = @"Failed to process authorization request";
                    break;
                case ASAuthorizationErrorUnknown:
                    errorMsg = @"Unknown reason for authorization request failure";
                    break;
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)checkButtonAction:(id)sender {
    if (@available(iOS 13.0, *)) {
        [[LEGOAppleSignInManager sharedInstance] checkAppleSignInStateCompletion:^(ASAuthorizationAppleIDProviderCredentialState credentialState) {
            switch (credentialState) {
                case ASAuthorizationAppleIDProviderCredentialRevoked:
                    // The user sign in to another apple ID again
                    break;
                case ASAuthorizationAppleIDProviderCredentialAuthorized:
                    // The user sign in status is nice
                    break;
                case ASAuthorizationAppleIDProviderCredentialNotFound:
                    // The user sign in could not be found
                    // The user is prohibited from setting - appleid header - password and security - app using your Apple ID
                    // ...
                    // ...
                    // The user log out from App
                    // ...
                    break;
                default:
            
                    break;
            }
            NSLog(@"credentialState=%ld",(long)credentialState);
        }];
    } else {
        // Fallback on earlier versions
    }
}

@end
