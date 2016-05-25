//
//  MASLoginWebViewController.m
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASLoginWebViewController.h"

#import <WebKit/WebKit.h>
#import "UIAlertController+MASUI.h"


@interface MASLoginWebViewController () <MASSocialLoginDelegate>


/**
 *  WKWebView
 */
@property (nonatomic, strong) WKWebView *webview;


/**
 *  MASAuthenticationProvider authentication provider for specific social login
 */
@property (nonatomic, strong) MASAuthenticationProvider *authenticationProvider;


/**
 *  Loading indicator
 */
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;


/**
 *  MASSocialLogin object to handle social login webview
 */
@property (nonatomic, strong) MASSocialLogin *socialLogin;


@end


@implementation MASLoginWebViewController


#
# pragma mark - Lifecycle
#

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [_authenticationProvider.identifier capitalizedString];
    
    if (!_webview)
    {
        _webview = [[WKWebView alloc] initWithFrame:self.view.bounds];
        
        [self.view addSubview:_webview];
        [self.view bringSubviewToFront:_activityIndicator];
        
        //
        //  Adding AutoLayout constraints as the webview is programmatically added
        //
        _webview.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_webview
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_webview
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_webview
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0f
                                                               constant:0.0f]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_webview
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0f
                                                               constant:0.0f]];
    }
    
    if (_authenticationProvider.authenticationUrl)
    {
        _socialLogin = [[MASSocialLogin alloc] initWithAuthenticationProvider:_authenticationProvider webView:_webview];
        _socialLogin.delegate = self;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}


#
# pragma mark - Public
#

- (void)setAuthenticationProvider:(MASAuthenticationProvider *)authenticationProvider
{
    
    NSAssert(authenticationProvider, @"MASAuthenticationProvider cannot be nil");
    
    _authenticationProvider = authenticationProvider;
}


#
# pragma mark - MASSocialLoginDelegate
#

- (void)didStartLoadingWebView
{
    //
    // Start loading indicator
    //
    [_activityIndicator startAnimating];
}


- (void)didStopLoadingWebView
{
    //
    // Stop loading indicator
    //
    [_activityIndicator stopAnimating];
}


- (void)didReceiveError:(NSError *)error
{
    //
    // Stop loading indicator
    //
    [_activityIndicator stopAnimating];
}


- (void)didReceiveAuthorizationCode:(NSString *)code
{
    //
    // Perform the request
    //
    DLog(@"\n\ncalling authorization code block: %@\n\n", self.authorizationCodeBlock);
    
    __block MASLoginWebViewController *blockSelf = self;
    
    self.authorizationCodeBlock(code, NO, ^(BOOL completed, NSError *error){
        
        DLog(@"\n\nblock callback: %@ or error: %@\n\n", (completed ? @"Yes" : @"No"), [error localizedDescription]);
        
        //
        // Ensure this code runs in the main UI thread
        //
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
                           //
                           // Handle the error
                           //
                           if(error)
                           {
                               //
                               // Display alert for user
                               //
                               [UIAlertController popupErrorAlert:error inViewController:blockSelf];
                               
                               return;
                           }
                           
                           if (_delegate && [_delegate respondsToSelector:@selector(didFinishLoginOnWebView)])
                           {
                               [_delegate didFinishLoginOnWebView];
                           }
                           
                           //
                           // Pop the view controller
                           //
                           [blockSelf.navigationController popToRootViewControllerAnimated:YES];
                       });
    });
}

@end
