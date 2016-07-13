//
//  MASTableViewCell.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>


/**
 * The base class for all MAS UITableViewCells.
 */
@interface MASTableViewCell : UITableViewCell


///--------------------------------------
/// @name Properties
///-------------------------------------

# pragma mark - Properties

/**
 * The NSString identifier of the cell.
 *
 * @return Returns NSString cell identifier.
 */
+ (NSString *)cellId;


/**
 * The CGFloat height of the cell.
 *
 * @return Returns CGFloat height of the cell.
 */
+ (CGFloat)cellHeight;

@end
