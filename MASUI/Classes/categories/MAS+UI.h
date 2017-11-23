//
//  MAS+UI.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <MASFoundation/MASFoundation.h>

#import "MASBaseLoginViewController.h"

/**
 *  This category enables UI features
 */
@interface MAS (UI)


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



/**
 * Detect if handling of Biometric authentication UI is enabled.
 *
 * @return Returns YES if enabled, NO if not.  The default is YES.
 */
+ (BOOL)willHandleBiometricAuthentication;



/**
 * Set the handling state of the Biometric authentication UI by this framework.
 *
 * @param handle YES if you want the framework to enable it, NO if not.
 *     YES is the default.
 */
+ (void)setWillHandleBiometricAuthentication:(BOOL)handle;



///--------------------------------------
/// @name Login Screen
///--------------------------------------

# pragma mark - Login Screen

/**
 Set the custom login view controller for MASUI to handle

 @param viewController view controller object that inherited MASBaseLoginViewController
 */
+ (void)setLoginViewController:(MASBaseLoginViewController *)viewController;



/**
 Return the currently set login view controller for MASUI

 @return view controller object that inherited MASBaseLoginViewController
 */
+ (MASBaseLoginViewController *)loginViewController;



///--------------------------------------
/// @name Lock Screen
///--------------------------------------

# pragma mark - Lock Screen


/**
 Set the custom lock screen view controller for MASUI to handle

 @param viewController view controller object that inherited MASViewController
 */
+ (void)setLockScreenViewController:(MASViewController *)viewController;




/**
 REturn the currently set lock screen view controller for MASUI

 @return view controller object that inherited MASViewController
 */
+ (MASViewController *)lockScreenViewController;

@end
