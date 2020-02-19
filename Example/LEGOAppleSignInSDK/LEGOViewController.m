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
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *state;

@end

@implementation LEGOViewController

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
        _label.textColor = [UIColor blackColor];
    }
    return _label;
}

- (UILabel *)state {
    if (!_state) {
        _state = [[UILabel alloc] init];
        _state.numberOfLines = 0;
        _state.textColor = [UIColor blackColor];
    }
    return _state;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkButtonAction:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(100);
    }];
    
    [self.view addSubview:self.state];
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.label.mas_top).offset(-15);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    

    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *signInButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleBlack];
        [signInButton addTarget:self action:@selector(signInWithApple:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:signInButton];
        
        [signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(185, 45));
        }];
        
        UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [signOutButton setTitle:@"sign out" forState:UIControlStateNormal];
        signOutButton.layer.cornerRadius = signInButton.cornerRadius;
        signOutButton.backgroundColor = [UIColor blackColor];
        signOutButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [signOutButton addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:signOutButton];
        
        [signOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(signInButton.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(185, 45));
        }];
        
        
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkButton setTitle:@"check system Sign in state" forState:UIControlStateNormal];
        checkButton.layer.cornerRadius = signInButton.cornerRadius;
        checkButton.backgroundColor = [UIColor blackColor];
        checkButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [checkButton addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkButton];
        
        [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(signOutButton.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(185, 45));
        }];
    }
    else {
        // Fallback on earlier versions
    }
    

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)signOut:(id)sender {
    self.label.text = @"app 中的登录状态：未登录";
}

- (void)signInWithApple:(id)sender {
    if (@available(iOS 13.0, *)) {
        [[LEGOAppleSignInManager sharedInstance] signInWithAppleByWindowAnchor:self.view.window success:^(LEGOAppleUserInfo * _Nonnull info) {
            // sign in sucess...
            self.label.text = [NSString stringWithFormat:@"app 中的登录状态：已登录\n\nuserId=%@\n\n\nidentityToken=%@\n",info.userId,[[NSString alloc] initWithData:info.identityToken encoding:NSUTF8StringEncoding]];
            [self checkButtonAction:nil];

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
            
            dispatch_async(dispatch_get_main_queue(),^{
                switch (credentialState) {
                    case ASAuthorizationAppleIDProviderCredentialRevoked:
                        // The user sign in to another apple ID again
                    {
                        self.state.text = @"设置中的状态：未登录";
                        [self signOut:nil];
                    }
                        break;
                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
                        // The user sign in status is nice
                    {
                        self.state.text = @"设置中的状态：已登录";
                        [self signOut:nil];
                    }
                        break;
                    case ASAuthorizationAppleIDProviderCredentialNotFound:
                        // The user sign in could not be found
                        // The user is prohibited from setting - appleid header - password and security - app using your Apple ID
                        // ...
                        // ...
                        // The user log out from App
                        // ...
                        {
                            self.state.text = @"设置中的状态：未登录";
                            [self signOut:nil];
                        }
                        break;
                    default:
                
                        break;
                }
                
            });
            
            NSLog(@"credentialState=%ld",(long)credentialState);
        }];
    } else {
        // Fallback on earlier versions
    }
}

@end
