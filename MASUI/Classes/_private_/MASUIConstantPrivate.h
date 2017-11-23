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



///--------------------------------------
/// @name MASFIDO/MASUI Constants
///--------------------------------------

# pragma mark - MASFIDO/MASUI Customization

/**
 * The NSString constant key for the biometric modality title.
 */
static NSString *const _Nonnull MASUIBiometricModalityTitleKey = @"title";


/**
 * The NSString constant key for the biometric modality policy code.
 */
static NSString *const _Nonnull MASUIBiometricModalityPolicyKey = @"policy";



/**
 * The NSString constant key for the biometric modality AAID.
 */
static NSString *const _Nonnull MASUIBiometricModalityAAIDKey = @"aaid";


/**
 * The NSString constant key for the biometric modality registration status.
 */
static NSString *const _Nonnull MASUIBiometricModalityRegistrationStatusKey = @"reg-status";



#define kSDKErrorDomain     @"com.ca.MASUI:ErrorDomain"

typedef NS_ENUM (NSUInteger, MASUIErrorCode)
{
    //
    // Login screen
    //
    MASUIErrorCodeInvalidLoginErrorCode = 200001,
    MASUIErrorCodeInvalidLockScreenErrorCode = 200002,
    
    //
    // User
    //
    MASUIErrorCodeUserAlreadyAuthenticated = 230001,
    MASUIErrorCodeLoginProcessCancel = 230005,
    MASUIErrorCodeUserSessionIsAlreadyUnlocked = 230007,
    
    //
    // Proximity Login
    //
    MASUIErrorCodeCurrentlyBeingAuthorized = 250101,
    
    //
    //  FIDO Login
    //
    MASUIErrorCodeMissingMASFIDOFramework = 260101,
    MASUIErrorCodeNothingSelected = 260102
    
};

#import "NSError+MASUIPrivate.h"
