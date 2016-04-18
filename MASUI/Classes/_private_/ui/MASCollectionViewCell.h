//
//  MASCollectionViewCell.h
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>


/**
 * The base class for all MAS UICollectionViewCells.
 */
@interface MASCollectionViewCell : UICollectionViewCell


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
 * The CGSize of the cell.
 *
 * @return Returns CGSize (height and width) of the cell.
 */
+ (CGSize)cellSize;

@end
