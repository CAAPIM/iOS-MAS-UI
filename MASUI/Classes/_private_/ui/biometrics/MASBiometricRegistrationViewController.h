//
//  MASBiometricRegistrationViewController.h
//  MASUI
//
//  Copyright (c) 2017 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>


@interface MASBiometricRegistrationViewController : UIViewController

///--------------------------------------
/// @name Properties
///--------------------------------------

# pragma mark - Properties

/**
 *  Available biometric modalities for registration.
 */
@property (nonatomic, strong, readwrite) NSArray *availableModalities;



/**
 *  completionBlock An MASBiometricModalitiesBlock
 *  (NSArray *_Nonnull biometricModalities, BOOL cancel, MASCompletionErrorBlock _Nullable)
 */
@property (nonatomic, copy) MASBiometricModalitiesBlock completionBlock;

@end
