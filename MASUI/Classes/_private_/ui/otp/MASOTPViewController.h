//
//  MASOTPViewController.h
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <MASUI/MASUI.h>


/**
 *  MASOTPViewController - ViewController class to handle One Time Password fetch.
 */
@interface MASOTPViewController : MASViewController



///--------------------------------------
/// @name Properties
///-------------------------------------

# pragma mark - Properties

/**
 *  MASOTPFetchCredentialsBlock
 */
@property (nonatomic, copy) MASOTPFetchCredentialsBlock otpCredentialsBlock;


/**
 *  NSError object to provide OTP error details. 
 */
@property (nonatomic, copy) NSError *otpError;

@end
