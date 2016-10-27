//
//  MASUser+MASUI.m
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASUser+MASUI.h"

#import "MASUIService.h"
#import "MASUIConstantPrivate.h"

@implementation MASUser (MASUI)

+ (void)presentLoginViewControllerWithCompletion:(MASCompletionErrorBlock)completion
{
    
    //
    //  If a user is currently authenticated, return an error
    //
    if ([MASUser currentUser] && [MASUser currentUser].isAuthenticated)
    {
        //
        //  Construct a NSError object with same error code from MASFoundation
        //
        NSError *error = [NSError errorForUIErrorCode:MASUIErrorCodeUserAlreadyAuthenticated errorDomain:kSDKErrorDomain];
        
        if (completion)
        {
            completion(NO, error);
        }
        
        return;
    }
    
    //
    //  If login view controller is not a subclass of MASBaseLoginViewController, return an error
    //
    if (![MASUIService loginViewController] || ![[MASUIService loginViewController] isKindOfClass:[MASBaseLoginViewController class]])
    {
        //
        //  Construct a NSError object
        //
        NSError *error = [NSError errorForUIErrorCode:MASUIErrorCodeInvalidLoginErrorCode errorDomain:kSDKErrorDomain];
        
        if (completion)
        {
            completion(NO, error);
        }
        
        return;
    }
    
    //
    //  Otherwise, retrieve the authentication providers
    //
    [MASAuthenticationProviders retrieveAuthenticationProvidersWithCompletion:^(id object, NSError *error) {
        
        //
        //  Present login view controller
        //
        [[MASUIService sharedService] presentLoginViewController:object completionBlock:completion];
    }];
}

@end
