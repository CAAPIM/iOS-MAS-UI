//
//  MASUIService.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <MASFoundation/MASFoundation.h>

#import "MASBaseLoginViewController.h"

@interface MASUIService : MASService



///--------------------------------------
/// @name Authentication Handling
///--------------------------------------

# pragma mark - Authentication Handling

/**
 * Detect if handling of authentication UI is enabled.
 *
 * @return Returns YES if enabled, NO if not.  The default is YES.
 */
+ (BOOL)willHandleAuthentication;


/**
 * Set the handling state of the authentication UI by this framework.
 *
 * @param handle YES if you want the framework to enable it, NO if not.
 *     YES is the default.
 */
+ (void)setWillHandleAuthentication:(BOOL)handle;



/**
 * Detect if handling of OTP authentication UI is enabled.
 *
 * @return Returns YES if enabled, NO if not.  The default is YES.
 */
+ (BOOL)willHandleOTPAuthentication;



/**
 * Set the handling state of the OTP authentication UI by this framework.
 *
 * @param handle YES if you want the framework to enable it, NO if not.
 *     YES is the default.
 */
+ (void)setWillHandleOTPAuthentication:(BOOL)handle;



///--------------------------------------
/// @name Login Screen
///--------------------------------------

# pragma mark - Login Screen


/**
 Set custom login view controller that inherited MASBaseLoginViewController

 @param viewController MASBaseLoginViewController
 */
+ (void)setLoginViewController:(MASBaseLoginViewController *)viewController;



/**
 Return currently set login view controller

 @return currently set login view controller
 */
+ (MASBaseLoginViewController *)loginViewController;



/**
 Present currently set login view controller as modal view

 @param providers              MASAuthenticationProviders object for social login and Proximity Login
 @param basicCredentialsBlock  MASBasicCrednetialsBlock for basic credentials authentication
 @param authorizationCodeBlock MASAuthorizationCodeCredentialsBlock for authorization code authentication
 */
- (void)presentLoginViewController:(MASAuthenticationProviders *)providers basicCredentialsBlock:(MASBasicCredentialsBlock)basicCredentialsBlock authorizationCodeBlock:(MASAuthorizationCodeCredentialsBlock)authorizationCodeBlock;



/**
 Present currently set login view controller as modal view

 @param providers       MASAuthenticationProviders object for social login and Proximity Login
 @param completionBlock MASCompletionErrorBlock to notify the original caller for the result of the authentication
 */
- (void)presentLoginViewController:(MASAuthenticationProviders *)providers completionBlock:(MASCompletionErrorBlock)completionBlock;



///--------------------------------------
/// @name Lock Screen
///--------------------------------------

# pragma mark - Lock Screen

+ (void)setLockScreenViewController:(MASViewController *)viewController;



+ (MASViewController *)lockScreenViewController;

@end
