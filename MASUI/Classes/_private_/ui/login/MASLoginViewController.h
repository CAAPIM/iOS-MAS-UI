//
//  MASLoginViewController.h
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASViewController.h"

@class MASAuthenticationProvider;


@interface MASLoginViewController : MASViewController



///--------------------------------------
/// @name Properties
///-------------------------------------

# pragma mark - Properties

@property (nonatomic, copy) MASAuthorizationCodeCredentialsBlock authorizationCodeBlock;
@property (nonatomic, copy) MASBasicCredentialsBlock basicCredentialsBlock;

@property (nonatomic, copy) NSArray *authenticationProviders;
@property (nonatomic, copy) NSString *availableProvider;
@property (nonatomic, strong) MASAuthenticationProvider *qrCodeProvider;

@end
