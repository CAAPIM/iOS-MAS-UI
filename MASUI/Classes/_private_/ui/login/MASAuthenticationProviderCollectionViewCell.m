//
//  MASAuthenticationProviderCollectionViewCell.m
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASAuthenticationProviderCollectionViewCell.h"

#import "UIImage+MASUI.h"


#define MASAuthenticationProviderCellIdSuffix @"Id"
#define MASAuthenticationProviderCellWidth 48.0
#define MASAuthenticationProviderCellHeight 48.0


@implementation MASAuthenticationProviderCollectionViewCell


#
# pragma mark - Lifecycle
#

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self.contentView.layer setCornerRadius:5.0];
    }
    
    return self;
}


#
# pragma mark - Public
#

+ (NSString *)cellId
{
    return [NSString stringWithFormat:@"%@%@", [[MASAuthenticationProviderCollectionViewCell class] description],
        MASAuthenticationProviderCellIdSuffix];
}


+ (CGSize)cellSize
{
    return CGSizeMake(MASAuthenticationProviderCellWidth, MASAuthenticationProviderCellHeight);
}


# pragma mark - Update

- (void)updateCellWithAuthenticationProvider:(MASAuthenticationProvider *)provider availableProvider:(NSString *)availableProvider
{
    DLog(@"called with provider:\n\n%@\n\n", provider);
    
    BOOL isAvailable = ([[availableProvider lowercaseString] isEqualToString:@"all"] || [availableProvider isEqualToString:provider.identifier]);
    //
    // Retrieve and set the image for that provider
    //
    UIImage *backgroundImage = [UIImage masUIAuthenticationProviderImageForKey:provider.identifier enabled:isAvailable];
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
}

@end
