//
//  MASUIService.m
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASUIService.h"

#import "MASLoginViewController.h"
#import "MASOTPChannelViewController.h"
#import "MASOTPViewController.h"
#import "NSBundle+MASUI.h"
#import "UIAlertController+MASUI.h"
#import "UIImage+MASUI.h"


@interface MASUIService ()

# pragma mark - Properties

@property (nonatomic, strong, readonly) MASLoginViewController *loginViewController;


/**
 *  OTP Credentials View Controller
 */
@property (nonatomic, strong, readonly) MASOTPViewController *otpViewController;


/**
 *  OTP Delivery Channels View Controller
 */
@property (nonatomic, strong, readonly) MASOTPChannelViewController *channelViewController;

@end


@implementation MASUIService

static BOOL _willHandleAuthentication_ = YES;
static BOOL _willHandleOTPAuthentication_ = YES;


# pragma mark - Shared Service

+ (instancetype)sharedService
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedInstance = [[MASUIService alloc] initProtected];
    });
    
    return sharedInstance;
}


# pragma mark - Lifecycle

+ (NSString *)serviceUUID
{
    // DO NOT change this without a corresponding change in MASFoundation
    return @"c15a0126-fe71-46bb-98f0-f87966b3beb4";
}


# pragma mark - Public

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@\n\n    will handle automated authentication: %@",
        [super debugDescription],
        (_willHandleAuthentication_ ? @"Yes" : @"No")];
}


# pragma mark - Authentication Handling

+ (BOOL)willHandleAuthentication
{
    return _willHandleAuthentication_;
}


+ (void)setWillHandleAuthentication:(BOOL)handle
{
    _willHandleAuthentication_ = handle;
}


+ (BOOL)willHandleOTPAuthentication
{
    return _willHandleOTPAuthentication_;
}


+ (void)setWillHandleOTPAuthentication:(BOOL)handle
{
    _willHandleOTPAuthentication_ = handle;
}


//
// Hidden: handle basic and social login, if any given
//

- (void)__masRequestsCredentialsWithAuthenticationProviders:(MASAuthenticationProviders *)providers
    basicCredentialsBlock:(MASBasicCredentialsBlock)basicCredentialsBlock
    authorizationCodeBlock__:(MASAuthorizationCodeCredentialsBlock)authorizationCodeBlock
{
    //DLog(@"\n\ncalled with basic block: %@ and code block: %@ providers: %@\n\n", basicCredentialsBlock, authorisationCodeBlock,  providers);
    
    if(!self.loginViewController)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            //
            // Init with the nib file from the bundle
            //
             //NSBundle *bundle = [NSBundle bundleForClass:[self class]]; //Used for dynamic framework
            
            NSBundle* bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]URLForResource:@"MASUIResources" withExtension:@"bundle"]]; //Used for Static framework

            _loginViewController = [[MASLoginViewController alloc] initWithNibName:@"MASLoginViewController" bundle:bundle];
        //[NSBundle masUIFramework]
            
            MASAuthenticationProvider *qrCodeAuthenticationProvider;
            NSMutableArray *mutableCopy = [NSMutableArray new];
            for(MASAuthenticationProvider *provider in providers.providers)
            {
                if([provider.identifier isEqualToString:MASUIAuthenticationProviderQrCodeImageKey])
                {
                    qrCodeAuthenticationProvider = provider;
                    continue;
                }
            
                [mutableCopy addObject:provider];
            }
        
            _loginViewController.basicCredentialsBlock = basicCredentialsBlock;
            _loginViewController.authorizationCodeBlock = authorizationCodeBlock;
            
            _loginViewController.authenticationProviders = mutableCopy;
            _loginViewController.qrCodeProvider = qrCodeAuthenticationProvider;
            _loginViewController.availableProvider = providers.idp;
        
            //
            // Show the controller
            //
            __block UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_loginViewController];
            
            [[UIAlertController rootViewController] presentViewController:navigationController animated:YES
                                                               completion:^
             {
                 _loginViewController = nil;
                 navigationController = nil;
             }];
            
            return;
        });
    }
    
    DLog(@"\n\nWarning you have called this method when a login view controller is already visible\n\n");
}


//
// Hidden: handle otp credentials flow
//

- (void)__masRequestsOTPCredentialsWithOTPCredentialsBlock__:(MASOTPFetchCredentialsBlock)otpCredentialsBlock error:(NSError *)otpError
{
    //DLog(@"\n\ncalled with otp fetch block: %@ and otpError:%@\n\n", otpCredentialsBlock, otpError);
    
    if(!self.otpViewController)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           //
                           // Init with the nib file from the bundle
                           //
                           //NSBundle *bundle = [NSBundle bundleForClass:[self class]]; //Used for dynamic framework
                           
                           NSBundle* bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]URLForResource:@"MASUIResources" withExtension:@"bundle"]]; //Used for Static framework
                           
                           _otpViewController = [[MASOTPViewController alloc] initWithNibName:@"MASOTPViewController" bundle:bundle];
                           
                           _otpViewController.otpError = otpError;
                           _otpViewController.otpCredentialsBlock = otpCredentialsBlock;
                           
                           //
                           // Show the controller
                           //
                           __block UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_otpViewController];
                           
                           [[UIAlertController rootViewController] presentViewController:navigationController
                                                                                animated:YES
                                                                              completion:^
                            {
                                _otpViewController = nil;
                                navigationController = nil;
                            }];
                           
                           return;
                       });
    }
    
    DLog(@"\n\nWarning you have called this method when a otp view controller is already visible\n\n");
}


//
// Hidden: handle otp channels flow
//

- (void)__masRequestsOTPChannelsWithOTPGenerationBlock__:(MASOTPGenerationBlock)otpGenerationBlock supportedChannels:(NSArray *)supportedChannels
{
    //DLog(@"\n\ncalled with otp generation block: %@ and supported channels : %@\n\n", otpGenerationBlock, supportedChannels);
    
    if(!self.channelViewController)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           //
                           // Init with the nib file from the bundle
                           //
                           //NSBundle *bundle = [NSBundle bundleForClass:[self class]]; //Used for dynamic framework
                           
                           NSBundle* bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]URLForResource:@"MASUIResources" withExtension:@"bundle"]]; //Used for Static framework
                           
                           _channelViewController = [[MASOTPChannelViewController alloc] initWithNibName:@"MASOTPChannelViewController" bundle:bundle];
                           
                           _channelViewController.otpGenerationBlock = otpGenerationBlock;                           
                           _channelViewController.supportedChannels = supportedChannels;
                           
                           //
                           // Show the controller
                           //
                           __block UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_channelViewController];
                           
                           [[UIAlertController rootViewController] presentViewController:navigationController
                                                                                animated:YES
                                                                              completion:^
                            {
                                _channelViewController = nil;
                                navigationController = nil;
                            }];
                           
                           return;
                       });
    }
    
    DLog(@"\n\nWarning you have called this method when a channel view controller is already visible\n\n");
}

@end
