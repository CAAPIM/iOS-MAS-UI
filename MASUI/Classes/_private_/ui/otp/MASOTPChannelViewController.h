//
//  MASOTPChannelViewController.h
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <MASUI/MASUI.h>


/**
 *  MASOTPChannelViewController - ViewController class to handle 
 *  One Time Password Channels fetch.
 */
@interface MASOTPChannelViewController : MASViewController



///--------------------------------------
/// @name Properties
///-------------------------------------

# pragma mark - Properties

/**
 *  MASOTPGenerationBlock
 */
@property (nonatomic, copy) MASOTPGenerationBlock otpGenerationBlock;


/**
 *  A server supported OTP channel list.
 */
@property (nonatomic, strong) NSArray *supportedChannels;

@end