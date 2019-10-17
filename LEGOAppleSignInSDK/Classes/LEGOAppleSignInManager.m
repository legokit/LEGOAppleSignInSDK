//
//  LEGOAppleSignInManager.m
//  LEGOAppleSignInSDK_Example
//
//  Created by 杨庆人 on 2019/10/15.
//  Copyright © 2019 564008993@qq.com. All rights reserved.
//

#import "LEGOAppleSignInManager.h"
#import "LEGOKeychainTool.h"

NSString *const kAppleSignInUserIdentity = @"kAppleSignInUserIdentity";

@interface LEGOAppleSignInManager ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, strong) ASPresentationAnchor windowAnchor;
@property (nonatomic, copy) LEGOAppleSignInSuccess success;
@property (nonatomic, copy) LEGOAppleSignInFail fail;

@end

@implementation LEGOAppleSignInManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    __strong static id _sharedObject = nil;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self.class alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    if (self = [super init]) {
        if (@available(iOS 13.0, *)) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAppleSignInState) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)checkAppleSignInState API_AVAILABLE(ios(13.0)) {
    if (@available(iOS 13.0, *)) {
        if (self.signInStatusChangedBlock) {
            [self checkAppleSignInStateCompletion:self.signInStatusChangedBlock];
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)checkAppleSignInStateCompletion:(LEGOAppleSignInStatusChanged)completion API_AVAILABLE(ios(13.0)) {
        if (@available(iOS 13.0, *)) {
        NSString *userId = [LEGOKeychainTool readKeychainValue:kAppleSignInUserIdentity];
        if (userId && userId.length) {
            ASAuthorizationAppleIDProvider *provider = [ASAuthorizationAppleIDProvider new];
            [provider getCredentialStateForUserID:userId completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
                if (completion) {
                    completion(credentialState);
                }
            }];
        }
    }
}

- (void)signInWithAppleByWindowAnchor:(ASPresentationAnchor)windowAnchor
                              success:(LEGOAppleSignInSuccess)success
                                 fail:(LEGOAppleSignInFail)fail API_AVAILABLE(ios(13.0)) {
    self.windowAnchor = windowAnchor;
    self.success = success;
    self.fail = fail;
    
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        controller.delegate = self;
        controller.presentationContextProvider = self;
        [controller performRequests];
    }
}

- (void)performExistingAccountSetupFlows API_AVAILABLE(ios(13.0)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
        [request setRequestedScopes:@[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail]];

        ASAuthorizationPasswordProvider *appleIDPasswordProvider = [ASAuthorizationPasswordProvider new];
        ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;

        NSArray *resquests = [NSArray arrayWithObjects:request, passwordRequest, nil];
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:resquests];
        controller.delegate = self;
        controller.presentationContextProvider = self;
        [controller performRequests];
}

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)) {
    return self.windowAnchor;
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *userId = appleIDCredential.user;
        NSData *identityToken = appleIDCredential.identityToken;
        NSString *email = appleIDCredential.email;
        NSPersonNameComponents *fullName = appleIDCredential.fullName;
        LEGOAppleUserInfo *info = [[LEGOAppleUserInfo alloc] init];
        info.credential = appleIDCredential;
        info.userId = userId;
        info.identityToken = identityToken;
        info.email = email;
        info.fullName = fullName;
        [LEGOKeychainTool saveKeychainValue:userId key:kAppleSignInUserIdentity];
        if (self.success) {
            self.success(info);
        }
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *userName = passwordCredential.user;
        NSString *password = passwordCredential.password;
        LEGOAppleUserInfo *info = [[LEGOAppleUserInfo alloc] init];
        info.credential = passwordCredential;
        info.userName = userName;
        info.password = password;
        if (self.success) {
            self.success(info);
        }
    } else {
        NSError *error = [NSError errorWithDomain:@"com.apple.AuthenticationServices.AuthorizationError" code:ASAuthorizationErrorUnknown userInfo:@{}];
        if (self.fail) {
            self.fail(error);
        }
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){

    if (self.fail) {
        self.fail(error);
    }
}

@end
