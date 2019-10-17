# LEGOAppleSignInSDK

[![CI Status](https://img.shields.io/travis/564008993@qq.com/LEGOAppleSignInSDK.svg?style=flat)](https://travis-ci.org/564008993@qq.com/LEGOAppleSignInSDK)
[![Version](https://img.shields.io/cocoapods/v/LEGOAppleSignInSDK.svg?style=flat)](https://cocoapods.org/pods/LEGOAppleSignInSDK)
[![License](https://img.shields.io/cocoapods/l/LEGOAppleSignInSDK.svg?style=flat)](https://cocoapods.org/pods/LEGOAppleSignInSDK)
[![Platform](https://img.shields.io/cocoapods/p/LEGOAppleSignInSDK.svg?style=flat)](https://cocoapods.org/pods/LEGOAppleSignInSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LEGOAppleSignInSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LEGOAppleSignInSDK'
```

**AppleSignIn** is the fast and easy way to implement ***Sign in with Apple*** introduced on Apple WWDC 2019.

**⚠️⚠️⚠️ WARNING ⚠️⚠️⚠️** **Sign in with Apple** is still in **BETA**. Everything in this library is tested and working but still can have unexpected results. Please, be careful.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Features

- [x] Initialization `Sign in with Apple` button from code.
- [x] Login with `default` button.
- [ ] Login with `custom` button.
- [x] Add use to Apple keychain.
- [x] Add `Cocoapods` support.

## Requirements

- iOS 13.0+
- Xcode 11.0+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate LEGOAppleSignInSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'LEGOAppleSignInSDK'
```

### Manually

If you prefer not to use any of the dependency mentioned above, you can integrate AppleSignIn into your project manually. Just drag & drop the `Sources` folder to your project.

## Usage

**Pre-requirments**:
- Set your development team in the **Signing & Capabilities** tab so Xcode can create a provisioning profile that uses the Sign In with Apple capability.
- Add **Sign In with Apple** capability.
- Choose a target device that you’re signed into with an Apple ID that uses Two-Factor Authentication.

```
/** sign in with Apple */
  if (@available(iOS 13.0, *)) {
        [[LEGOAppleSignInManager sharedInstance] signInWithAppleByWindowAnchor:self.view.window success:^(LEGOAppleUserInfo * _Nonnull info) {
            // sign in sucess...
        } fail:^(NSError * _Nonnull error) {
            // sign in fail...
        }];
    } 
    else {
        // Fallback on earlier versions
    }
```

```
/** chenk Apple's sign in state */
    if (@available(iOS 13.0, *)) {
        [[LEGOAppleSignInManager sharedInstance] checkAppleSignInStateCompletion:^(ASAuthorizationAppleIDProviderCredentialState credentialState) {

        }];
    } 
    else {
        // Fallback on earlier versions
    }
```

For details, see example for LEGOAppleSignInSDK.

## Author

564008993@qq.com, yangqingren@yy.com

## License

LEGOAppleSignInSDK is available under the MIT license. See the LICENSE file for more info.




