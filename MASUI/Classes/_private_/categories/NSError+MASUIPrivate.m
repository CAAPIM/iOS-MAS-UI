//
//  NSError+MASUIPrivate.m
//  MASUI
//
//  Created by Hun Go on 2016-10-26.
//  Copyright © 2016 CA Technologies. All rights reserved.
//

#import "NSError+MASUIPrivate.h"

@implementation NSError (MASUIPrivate)

+ (NSError *)errorForUIErrorCode:(MASUIErrorCode)errorCode errorDomain:(NSString *)errorDomain
{
    return [self errorForUIErrorCode:errorCode info:nil errorDomain:errorDomain];
}


+ (NSError *)errorForUIErrorCode:(MASUIErrorCode)errorCode info:(NSDictionary *)info errorDomain:(NSString *)errorDomain
{
    //
    // Standard error key/values
    //
    NSMutableDictionary *errorInfo = [NSMutableDictionary new];
    if(![info objectForKey:NSLocalizedDescriptionKey])
    {
        errorInfo[NSLocalizedDescriptionKey] = [self descriptionForUIErrorCode:errorCode];
    }
    
    [errorInfo addEntriesFromDictionary:info];
    
    return [NSError errorWithDomain:errorDomain code:errorCode userInfo:errorInfo];
}


+ (NSString *)descriptionForUIErrorCode:(MASUIErrorCode)errorCode
{
    //
    // Detect code and respond appropriately
    //
    switch(errorCode)
    {
            //
            // Login screen
            //
        case MASUIErrorCodeInvalidLoginErrorCode: return @"Invalid login view controller.  Login view controller should subclass from MASBaseLoginViewController";
        case MASUIErrorCodeInvalidLockScreenErrorCode: return @"Invalid lock screen view controller.  Lock screen view controller should subclass from MASViewController";
            
            //
            // User
            //
        case MASUIErrorCodeUserAlreadyAuthenticated: return @"A user is already authenticated";
        case MASUIErrorCodeCurrentlyBeingAuthorized: return @"Authorization is currently in progress through session sharing";
        case MASUIErrorCodeUserSessionIsAlreadyUnlocked: return @"User session is not locked";
            
            //
            // FIDO Login
            //
        case MASUIErrorCodeMissingMASFIDOFramework: return @"MASFIDO framework not found.";
            //
            // Default
            //
            
        default: return [NSString stringWithFormat:@"Unrecognized error code of value: %ld", (long)errorCode];
    }
}

@end
