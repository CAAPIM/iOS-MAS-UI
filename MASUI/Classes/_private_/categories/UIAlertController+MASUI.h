//
//  UIAlertController+MASUI.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>


@interface UIAlertController (MASUI)



///--------------------------------------
/// @name Authentication Alerts
///-------------------------------------

# pragma mark - Authentication Alerts

/**
 * Displays on screen an authentication UIAlertController modally in the currently
 * visible UIViewController.
 */
+ (void)popupAuthenticationAlert;


/**
 * Displays on screen an authentication UIAlertController modally in the selected
 * UIViewController modally.
 *
 * @param viewController The UIViewController in which to present the modal UIAlertController.
 */
+ (void)popupAuthenticationAlertInViewController:(UIViewController *)viewController;



///--------------------------------------
/// @name Error Alerts
///-------------------------------------

# pragma mark - Error Alerts

/**
 * Displays on screen an error UIAlertController modally in the currently
 * visible UIViewController.
 */
+ (void)popupErrorAlert:(NSError *)error;


/**
 * Displays on screen an error UIAlertController modally in the selected
 * UIViewController modally.
 *
 * @param error The NSError contents to show in the UIAlertController.
 * @param viewController The UIViewController in which to present the modal UIAlertController.
 */
+ (void)popupErrorAlert:(NSError *)error inViewController:(UIViewController *)viewController;



///--------------------------------------
/// @name Public
///-------------------------------------

# pragma mark - Public

/**
 * Retrieve the currently visible UIViewController.
 */
+ (UIViewController *)rootViewController;

@end