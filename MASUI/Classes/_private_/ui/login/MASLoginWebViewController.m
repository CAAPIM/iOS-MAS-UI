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


@interface MASLoginWebViewController () <WKNavigationDelegate, UIWebViewDelegate>


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
        _webview.navigationDelegate = self;
        
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
        // Get all data type
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        // Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        // Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            // Process the request after deleting all cache and other data
            NSURLRequest *request = [NSURLRequest requestWithURL:_authenticationProvider.authenticationUrl];
            [_webview loadRequest:request];
        }];
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
# pragma mark - WKNavigationDelegate
#

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    //
    // Start loading indicator
    //
    [_activityIndicator startAnimating];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    //
    // Stop loading indicator
    //
    [_activityIndicator stopAnimating];
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    //
    // Stop loading indicator
    //
    [_activityIndicator stopAnimating];
}


- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    DLog(@"server redirect : %@", [webView.URL description]);
    
    NSRange range = [[webView.URL description] rangeOfString:[MASApplication currentApplication].redirectUri.absoluteString];
    
    if (range.length>0){
        
        DLog(@"request matches the registered the rediect URI");
        
        NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
        NSArray *urlComponentsSeperatedwithQuestionMark = [[webView.URL description] componentsSeparatedByString:@"?"];
        NSString *redirect_uri = urlComponentsSeperatedwithQuestionMark[0];
        NSArray *urlComponents = [urlComponentsSeperatedwithQuestionMark[1] componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents)
        {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents objectAtIndex:0];
            NSString *value = [pairComponents objectAtIndex:1];
            
            [queryStringDictionary setObject:value forKey:key];
        }
        
        if([redirect_uri isEqualToString:[MASApplication currentApplication].redirectUri.absoluteString]){
            
            //
            //  Stop loading webview for further request
            //
            [_webview stopLoading];
            
            //
            // Perform the request
            //
            DLog(@"\n\ncalling basic credentials block: %@\n\n", self.basicCredentialsBlock);
            
            __block MASLoginWebViewController *blockSelf = self;
            
            self.authorizationCodeBlock([queryStringDictionary objectForKey:@"code"], NO, ^(BOOL completed, NSError *error){
                
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
    }
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        disposition = NSURLSessionAuthChallengeUseCredential;
    }
    
    completionHandler(disposition, credential);
}


@end
