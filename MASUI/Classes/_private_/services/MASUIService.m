//
//  MASUIService.m
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASUIService.h"

#import "NSBundle+MASUI.h"
#import "UIImage+MASUI.h"
#import "UIAlertController+MASUI.h"

#import "MASOTPViewController.h"
#import "MASLoginViewController.h"
#import "MASOTPChannelViewController.h"
#import "MASSessionLockViewController.h"
#import "MASBiometricRegistrationViewController.h"
#import "MASBiometricDeregistrationViewController.h"


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


/**
 *  Biometric Registration Modalities Selection View Controller
 */
@property (nonatomic, strong, readonly) MASBiometricRegistrationViewController *biometricRegViewController;


/**
 *  Biometric Deregistration Modalities Selection View Controller
 */
@property (nonatomic, strong, readonly) MASBiometricDeregistrationViewController *biometricDeregViewController;

@end


@implementation MASUIService

static BOOL _willHandleAuthentication_ = YES;
static BOOL _willHandleOTPAuthentication_ = YES;
static BOOL _willHandleBiometricAuthentication_ = YES;
static MASBaseLoginViewController * _loginViewController_ = nil;
static MASViewController * _lockScreenViewController_ = nil;


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

+ (void)load
{
    [MASService registerSubclass:[self class] serviceUUID:@"c15a0126-fe71-46bb-98f0-f87966b3beb4"];
}


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


+ (BOOL)willHandleBiometricAuthentication
{
    return _willHandleBiometricAuthentication_;
}


+ (void)setWillHandleBiometricAuthentication:(BOOL)handle
{
    _willHandleBiometricAuthentication_ = handle;
}


# pragma mark - Login Screen

+ (void)setLoginViewController:(MASBaseLoginViewController *)viewController
{
    _loginViewController_ = viewController;
}


+ (MASBaseLoginViewController *)loginViewController
{
    return _loginViewController_;
}


- (void)presentLoginViewController:(MASAuthenticationProviders *)providers authCredentialsBlock:(MASAuthCredentialsBlock)authCredentialsBlock completionBlock:(MASCompletionErrorBlock)completionBlock
{
    _loginViewController_.authCredentialsBlock = nil;
    _loginViewController_.completionBlock = nil;
    
    _loginViewController_.authCredentialsBlock = authCredentialsBlock;
    _loginViewController_.completionBlock = completionBlock;
    
    
    MASAuthenticationProvider *qrCodeAuthenticationProvider;
    NSMutableArray *authProviders = [NSMutableArray new];
    for(MASAuthenticationProvider *provider in providers.providers)
    {
        if([provider.identifier isEqualToString:MASUIAuthenticationProviderQrCodeImageKey])
        {
            qrCodeAuthenticationProvider = provider;
            continue;
        }
        
        [authProviders addObject:provider];
    }
    
    _loginViewController_.availableProvider = providers.idp;
    _loginViewController_.socialLoginAuthenticationProviders = authProviders;
    _loginViewController_.proximityLoginProvider = qrCodeAuthenticationProvider;
    
    //
    // Show the controller
    //
    __block UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_loginViewController_];
    
    //
    // Notify view controller for handle UI refresh
    //
    [_loginViewController_ viewWillReload];
    
    [UIAlertController rootViewController].modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [[UIAlertController rootViewController] presentViewController:navigationController animated:YES
                                                       completion:^{
                                                           
                                                           [_loginViewController_ viewDidReload];
                                                           navigationController = nil;
                                                       }];
}


- (void)presentSessionLockViewController
{
    //
    // Show the controller
    //
    __block UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_lockScreenViewController_];
    
    [UIAlertController rootViewController].modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[UIAlertController rootViewController] presentViewController:navigationController animated:NO
                                                       completion:^{
                                                           
                                                           navigationController = nil;
                                                       }];
}


# pragma mark - Lifecycle

- (void)serviceWillStart
{
    [super serviceWillStart];
    
    NSBundle* bundle = [NSBundle masUIFramework]; 
    
    if (!_loginViewController_)
    {
        _loginViewController_ = (MASBaseLoginViewController *)[[MASLoginViewController alloc] initWithNibName:@"MASLoginViewController" bundle:bundle];
    }
    
    if (!_lockScreenViewController_)
    {
        _lockScreenViewController_ = (MASViewController *)[[MASSessionLockViewController alloc] initWithNibName:@"MASSessionLockViewController" bundle:bundle];
    }
}


# pragma mark - Lock Screen

+ (void)setLockScreenViewController:(MASViewController *)viewController
{
    _lockScreenViewController_ = viewController;
}


+ (MASViewController *)lockScreenViewController
{
    return _lockScreenViewController_;
}


# pragma mark - Private
//
// Hidden: handle basic and social login, if any given
//

- (void)__masRequestsCredentialsWithAuthenticationProviders__:(MASAuthenticationProviders *)providers
                                         authCredentialsBlock:(MASAuthCredentialsBlock)authCredentialsBlock
{
    if (!self.loginViewController)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self presentLoginViewController:providers authCredentialsBlock:authCredentialsBlock completionBlock:nil];
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
                           NSBundle* bundle = [NSBundle masUIFramework];
                           
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
                           NSBundle* bundle = [NSBundle masUIFramework];
                           
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


//
// Hidden: handle biometric modalities registration flow
//

- (void)__masRequestsRegistrationModalitySelectionWithModalities__:(NSArray *)availableModalities
                                                   completionBlock:(MASBiometricModalitiesBlock)completionBlock
{
    //DLog(@"\n\ncalled with biometric modalities block: %@ and available modalities : %@\n\n", completionBlock, availableModalities);
    
    if(!self.biometricRegViewController)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           //
                           // Init with the nib file from the bundle
                           //
                           NSBundle* bundle = [NSBundle masUIFramework];
                           
                           _biometricRegViewController = [[MASBiometricRegistrationViewController alloc] initWithNibName:@"MASBiometricRegistrationViewController" bundle:bundle];
                           
                           _biometricRegViewController.completionBlock = completionBlock;
                           _biometricRegViewController.availableModalities = availableModalities;
                           
                           //
                           // Show the controller
                           //
                           __block UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_biometricRegViewController];
                           
                           [[UIAlertController rootViewController] presentViewController:navigationController
                                                                                animated:YES
                                                                              completion:^
                            {
                                _biometricRegViewController = nil;
                                navigationController = nil;
                            }];
                           
                           return;
                       });
    }
    
    DLog(@"\n\nWarning you have called this method when a biometric view controller is already visible\n\n");
}


//
// Hidden: handle biometric modalities deregistration flow
//

- (void)__masRequestsDeregistrationModalitySelectionWithModalities__:(NSArray *)availableModalities
                                                     completionBlock:(MASBiometricModalitiesBlock)completionBlock
{
    //DLog(@"\n\ncalled with biometric modalities block: %@ and available modalities : %@\n\n", completionBlock, availableModalities);
    
    if(!self.biometricDeregViewController)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           //
                           // Init with the nib file from the bundle
                           //
                           NSBundle* bundle = [NSBundle masUIFramework];
                           
                           _biometricDeregViewController = [[MASBiometricDeregistrationViewController alloc] initWithNibName:@"MASBiometricDeregistrationViewController" bundle:bundle];
                           
                           _biometricDeregViewController.completionBlock = completionBlock;
                           _biometricDeregViewController.availableModalities = availableModalities;
                           
                           //
                           // Show the controller
                           //
                           __block UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_biometricDeregViewController];
                           
                           [[UIAlertController rootViewController] presentViewController:navigationController
                                                                                animated:YES
                                                                              completion:^
                            {
                                _biometricDeregViewController = nil;
                                navigationController = nil;
                            }];
                           
                           return;
                       });
    }
    
    DLog(@"\n\nWarning you have called this method when a biometric view controller is already visible\n\n");
}

@end
