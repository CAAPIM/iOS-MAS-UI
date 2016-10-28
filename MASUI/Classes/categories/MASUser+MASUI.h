//
//  MASUser+MASUI.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <MASFoundation/MASFoundation.h>

@interface MASUser (MASUI)

/**
 Display currently set login view controller in MASUI for authentication

 @param completion MASCompletionErrorBlock to notify the result of the authentication.
 */
+ (void)presentLoginViewControllerWithCompletion:(MASCompletionErrorBlock)completion;



/**
 Display currently set lock screen view controller in MASUI for locked session
 
 @param completion MASCompletionErrorBlock to notify the result of the displaying lock screen.
 */
+ (void)presentSessionLockScreenViewController:(MASCompletionErrorBlock)completion;

@end
