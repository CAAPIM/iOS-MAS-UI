//
//  NSBundle+MASUI.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <Foundation/Foundation.h>


@interface NSBundle (MASUI)



///--------------------------------------
/// @name Frameworks
///-------------------------------------

# pragma mark - Frameworks

/**
 * Retrieve the specific MASUI framework NSBundle.
 *
 * @return Returns the MASUI framework NSBundle.
 */
+ (NSBundle *)masUIFramework;

@end
