//
//  MASBaseLoginViewController.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASViewController.h"


/**
 Base ViewController class for customized login dialog through MASUI framework.  To customize the login dialog which will be displayed by MASUI and MASFoundation SDKs, please inherite from this base class, and implement UI elements in this ViewController.

 @warning Please DO NOT manually or programmatically change or update any of the properties in this class as these will be used to authenticate the user based on mutually agreed protocol in between MASFoundation and MASUI.
 
 @see Please refer to public methods to implement login functionalities.
 */
@interface MASBaseLoginViewController : MASViewController

///--------------------------------------
/// @name Properties
///-------------------------------------

# pragma mark - Properties


/**
 @warning DO NOT MANUALLY MODIFY THIS PROPERTY
 
 MASAuthCredentialsBlock to handle auth credential login.
 */
@property (nonatomic, copy) MASAuthCredentialsBlock authCredentialsBlock;


/**
 @warning DO NOT MANUALLY MODIFY THIS PROPERTY
 
 MASCompletionErrorBlock to notify original caller for the result of the login.
 */
@property (nonatomic, copy) MASCompletionErrorBlock completionBlock;


/**
 @warning DO NOT MANUALLY MODIFY THIS PROPERTY
 
 NSArray of MASAuthenticationProvider for social login.
 */
@property (nonatomic, strong) NSArray *socialLoginAuthenticationProviders;


/**
 @warning DO NOT MANUALLY MODIFY THIS PROPERTY
 
 NSString of currently available MASAuthenticationProvider.
 */
@property (nonatomic, strong) NSString *availableProvider;


/**
 @warning DO NOT MANUALLY MODIFY THIS PROPERTY
 
 MASAuthenticationProvider for Proximity Login.
 */
@property (nonatomic, strong) MASAuthenticationProvider *proximityLoginProvider;


# pragma mark - Public Method


/**
 A method to clean up or re-organize all UI elements in view controller before it is presented.  This method will be invoked BEFORE the view controller is presented.
 All UI elements related to authentication logic, (i.e. button states, QR Code image, Social Login authentication providers), should be re-loaded on this method.
 */
- (void)viewWillReload;



/**
 A method to clean up or re-organize all UI elements in view controller after it is presented.  This method will be invoked RIGHT AFTER the view controller is presented.
 All UI elements related to authentication logic, (i.e. button states, QR Code image, Social Login authentication providers), should be re-loaded on this method.
 */
- (void)viewDidReload;



/**
 Login with provided username and password.  By invoking this method with username and password, this will trigger login process.

 @param username   NSString of username
 @param password   NSString of password
 @param completion MASCompletionErrorBlock that will notify the result of the login
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(MASCompletionErrorBlock)completion;



/**
 Login with authorization code.  By invoking this method with authorization code, this will trigger login process.

 @param authorizationCode NSString of authorization code
 @param completion        MASCompletionErrorBlock that will notify the result of the login
 */
- (void)loginWithAuthorizationCode:(NSString *)authorizationCode completion:(MASCompletionErrorBlock)completion;



/**
 Login with provided FIDO username.  By invoking this method with FIDO username, this will trigger FIDO login process.
 
 @param username   NSString of username
 @param completion MASCompletionErrorBlock that will notify the result of the FIDO login
 */
- (void)loginWithFIDOUsername:(NSString *)userName completion:(MASCompletionErrorBlock)completion;



/**
 Cancel the login process and dismiss currently presented login view controller
 */
- (void)cancel;



/**
 Dismiss login view controller

 @param animated   BOOL value whether dimiss will be animated or not
 @param completion Completion block which will be invoked, if provided, once view controller is dismissed
 */
- (void)dismissLoginViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion;

@end
