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
    
    if (_basicCredentialsBlock)
    {
        _basicCredentialsBlock(username, password, NO, ^(BOOL completed, NSError *error){
         
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
    
    if (_authorizationCodeBlock)
    {
        _authorizationCodeBlock(authorizationCode, NO, ^(BOOL completed, NSError *error){
            
            blockCompletion(completed, error);
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


- (void)cancel
{
    if (_basicCredentialsBlock)
    {
        _basicCredentialsBlock(nil, nil, YES, nil);
    }
    else if (_authorizationCodeBlock)
    {
        _authorizationCodeBlock(nil, YES, nil);
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
