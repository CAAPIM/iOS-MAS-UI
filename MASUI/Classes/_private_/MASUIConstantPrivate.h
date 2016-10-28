//
//  MASUIConstantPrivate.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#ifndef MASUIConstantPrivate_h
#define MASUIConstantPrivate_h


#endif /* MASUIConstantPrivate_h */

#define kSDKErrorDomain     @"com.ca.MASUI:ErrorDomain"

typedef NS_ENUM (NSUInteger, MASUIErrorCode)
{
    //
    // Login screen
    //
    MASUIErrorCodeInvalidLoginErrorCode = 200001,
    
    //
    // User
    //
    MASUIErrorCodeUserAlreadyAuthenticated = 230001,
    MASUIErrorCodeLoginProcessCancel = 230005,
    
    //
    // Proximity Login
    //
    MASUIErrorCodeCurrentlyBeingAuthorized = 250101
    
};

#import "NSError+MASUIPrivate.h"
