//
//  MASAuthenticationProviderCollectionViewCell.h
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASCollectionViewCell.h"

@class MASAuthenticationProvider;


/**
 * A sublcass of MASCollectionViewCell used specifically to show MASAuthenticationProvider
 * options within a UICollectionView.
 */
@interface MASAuthenticationProviderCollectionViewCell : MASCollectionViewCell



///--------------------------------------
/// @name Update
///-------------------------------------

# pragma mark - Update

/**
 * Update the cell's visual contents with the data contained within a MASAuthenticationProvider.
 *
 * @param provider The MASAuthenticationProvider instance.
 */
- (void)updateCellWithAuthenticationProvider:(MASAuthenticationProvider *)provider availableProvider:(NSString *)availableProvider;

@end
