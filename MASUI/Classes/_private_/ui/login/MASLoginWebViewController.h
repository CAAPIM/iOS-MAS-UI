//
//  MASLoginWebViewController.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASViewController.h"

@protocol MASLoginWebViewControllerProtocol;


/**
 *  MASLoginWebViewController - ViewController class to handle authentication provider for social login
 */
@interface MASLoginWebViewController : MASViewController


/**
 *  MASAuthorizationCodeCredentialsBlock
 */
@property (nonatomic, copy) MASAuthorizationCodeCredentialsBlock authorizationCodeBlock;


/**
 *  MASBasicCredentialsBlock
 */
@property (nonatomic, copy) MASBasicCredentialsBlock basicCredentialsBlock;


/**
 * The MASLoginWebViewControllerProtocol delegate.
 */
@property id<MASLoginWebViewControllerProtocol> delegate;


#
# pragma mark - Public
#

/**
 *  Set authentication provider for social login
 *
 *  @param authenticationProvider MASAuthenticationProvider object contains authentication provider's information
 */
- (void)setAuthenticationProvider:(MASAuthenticationProvider *)authenticationProvider;

@end


/**
 *  MASLoginWebViewController protocol to notify an activity on the webview
 */
@protocol MASLoginWebViewControllerProtocol <NSObject>


// optional protocol method
@optional

/**
 *  delegation method to handle when the login was finished
 */
- (void)didFinishLoginOnWebView;



/**
 Delegation method to handle when the authorization code was received

 @param authorizationCode NSString of authorization code received from the server
 */
- (void)didReceiveAuthorizationCode:(NSString *)authorizationCode;

@end
