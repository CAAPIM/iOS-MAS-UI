//
//  MAS+UI.m
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MAS+UI.h"

#import "MASUIService.h"


@implementation MAS (UI)


# pragma mark - Authentication Handling

+ (BOOL)willHandleAuthentication
{
    return [MASUIService willHandleAuthentication];
}


+ (void)setWillHandleAuthentication:(BOOL)handle
{
    [MASUIService setWillHandleAuthentication:handle];
}


+ (BOOL)willHandleOTPAuthentication
{
    return [MASUIService willHandleOTPAuthentication];
}


+ (void)setWillHandleOTPAuthentication:(BOOL)handle
{
    [MASUIService setWillHandleOTPAuthentication:handle];
}


+ (BOOL)willHandleBiometricAuthentication
{
    return [MASUIService willHandleBiometricAuthentication];
}


+ (void)setWillHandleBiometricAuthentication:(BOOL)handle
{
    [MASUIService setWillHandleBiometricAuthentication:handle];
}


+ (void)setLoginViewController:(MASBaseLoginViewController *)viewController
{
    [MASUIService setLoginViewController:viewController];
}


+ (MASBaseLoginViewController *)loginViewController
{
    return [MASUIService loginViewController];
}


///--------------------------------------
/// @name Lock Screen
///--------------------------------------

# pragma mark - Lock Screen

+ (void)setLockScreenViewController:(MASViewController *)viewController
{
    [MASUIService setLockScreenViewController:viewController];
}


+ (MASViewController *)lockScreenViewController
{
    return [MASUIService lockScreenViewController];
}

@end
