//
//  MASBaseLoginViewController.m
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASBaseLoginViewController.h"

#import "MASUIConstantPrivate.h"

@interface MASBaseLoginViewController ()

@end

@implementation MASBaseLoginViewController

# pragma mark - Public

- (void)viewWillReload
{
    
}


- (void)viewDidReload
{
    
}


- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(MASCompletionErrorBlock)completion
{
    //
    // Display an error if device is being authorized through other session sharing method.
    //
    if ([[MASDevice currentDevice] isBeingAuthorized])
    {
        
        NSError *error = [NSError errorForUIErrorCode:MASUIErrorCodeCurrentlyBeingAuthorized errorDomain:kSDKErrorDomain];
        
        if (completion)
        {
            completion(NO, error);
        }
        
        return;
    }
    
    __block MASCompletionErrorBlock blockCompletion = completion;
    
    if (_authCredentialsBlock)
    {
        MASAuthCredentialsPassword *authCredentials = [MASAuthCredentialsPassword initWithUsername:username password:password];
        _authCredentialsBlock(authCredentials, NO, ^(BOOL completed, NSError *error) {
            
            if (_completionBlock)
            {
                _completionBlock(completed, error);
            }
            
            if (blockCompletion)
            {
                blockCompletion(completed, error);
            }
        });
    }
    else {
        
        [MASUser loginWithUserName:username password:password completion:^(BOOL completed, NSError *error) {
            
            if (_completionBlock)
            {
                _completionBlock(completed, error);
            }
            
            if (blockCompletion)
            {
                blockCompletion(completed, error);
            }
        }];
    }
}


- (void)loginWithAuthorizationCode:(NSString *)authorizationCode completion:(MASCompletionErrorBlock)completion
{
    
    __block MASCompletionErrorBlock blockCompletion = completion;
    
    if (_authCredentialsBlock)
    {
        MASAuthCredentialsAuthorizationCode *authCredentials = [MASAuthCredentialsAuthorizationCode initWithAuthorizationCode:authorizationCode];
        _authCredentialsBlock(authCredentials, NO, ^(BOOL completed, NSError *error) {
            
            if (_completionBlock)
            {
                _completionBlock(completed, error);
            }
            
            if (blockCompletion)
            {
                blockCompletion(completed, error);
            }
        });
    }
    else {
        
        [MASUser loginWithAuthorizationCode:authorizationCode completion:^(BOOL completed, NSError *error) {
            
            if (_completionBlock)
            {
                _completionBlock(completed, error);
            }
            
            if (blockCompletion)
            {
                blockCompletion(completed, error);
            }
        }];
    }
}

- (void)loginWithFIDOUsername:(NSString *)userName completion:(MASCompletionErrorBlock)completion {
    
    //
    // Display an error if device is being authorized through other session sharing method.
    //
    if ([[MASDevice currentDevice] isBeingAuthorized])
    {
        
        NSError *error = [NSError errorForUIErrorCode:MASUIErrorCodeCurrentlyBeingAuthorized errorDomain:kSDKErrorDomain];
        
        if (completion)
        {
            completion(NO, error);
        }
        
        return;
    }
    
    __block MASCompletionErrorBlock blockCompletion = completion;
    
    if (_authCredentialsBlock) {
        
        SEL selector = NSSelectorFromString(@"initWithUserName:");
        Class authCredentialsFIDOClass = NSClassFromString(@"MASAuthCredentialsFIDO");
        if (![authCredentialsFIDOClass respondsToSelector:selector]) {
            
            NSError *error = [NSError errorForUIErrorCode:MASUIErrorCodeMissingMASFIDOFramework errorDomain:kSDKErrorDomain];
            
            if (_completionBlock)
            {
                _completionBlock(NO, error);
            }

            if (blockCompletion)
            {
                blockCompletion(NO, error);
            }
        }
        
        IMP imp = [authCredentialsFIDOClass methodForSelector:selector];
        __block id (*initWithUserName)(id, SEL, NSString*) = (void *)imp;
        
        id authCredentialsFIDO =
            initWithUserName(authCredentialsFIDOClass, selector, userName);
        
        MASAuthCredentials *authCredentials = (MASAuthCredentials *)authCredentialsFIDO;
        
        _authCredentialsBlock(authCredentials, NO, ^(BOOL completed, NSError *error) {
            
            if (_completionBlock)
            {
                _completionBlock(completed, error);
            }
            
            if (blockCompletion)
            {
                blockCompletion(completed, error);
            }
        });
    }
    else {
        
        SEL selector = NSSelectorFromString(@"loginWithFIDOUserName:completion:");
        if (![MASUser respondsToSelector:selector]) {
            
            NSError *error = [NSError errorForUIErrorCode:MASUIErrorCodeMissingMASFIDOFramework errorDomain:kSDKErrorDomain];
            
            if (_completionBlock)
            {
                _completionBlock(NO, error);
            }
            
            if (blockCompletion)
            {
                blockCompletion(NO, error);
            }
        }
        
        IMP imp = [MASUser methodForSelector:selector];
        __block void (*loginWithFIDOUserName)(id, SEL, NSString*, MASCompletionErrorBlock) = (void *)imp;
        
        loginWithFIDOUserName(MASUser.class, selector, userName, ^(BOOL completed, NSError *error) {
            
            if (_completionBlock)
            {
                _completionBlock(completed, error);
            }
            
            if (blockCompletion)
            {
                blockCompletion(completed, error);
            }
        });
    }
}


- (void)cancel
{
    if (_authCredentialsBlock)
    {
        _authCredentialsBlock(nil, YES, nil);
    }
    
    if (_completionBlock)
    {
        NSError *error = [NSError errorForUIErrorCode:MASUIErrorCodeLoginProcessCancel errorDomain:kSDKErrorDomain];
        
        _completionBlock(NO, error);
    }
    
    [self dismissLoginViewControllerAnimated:YES completion:nil];
}


- (void)dismissLoginViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion
{

    [self dismissViewControllerAnimated:animated completion:completion];
}

@end
