//
//  MASAuthenticationProviderCollectionViewCell.m
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASAuthenticationProviderCollectionViewCell.h"

#import "UIImage+MASUI.h"


#define MASAuthenticationProviderCellIdSuffix @"Id"
#define MASAuthenticationProviderCellWidth 136.0
#define MASAuthenticationProviderCellHeight 40.0


@interface MASAuthenticationProviderCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *iconImgView;
@property (nonatomic, weak) IBOutlet UILabel *providerLabel;
@property (nonatomic, weak) IBOutlet UIView *dropShadowView;

@end

@implementation MASAuthenticationProviderCollectionViewCell


#
# pragma mark - Lifecycle
#

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        
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

    [self.iconImgView setImage:backgroundImage];
    [self.providerLabel setText:[self retrieveProperNameForIdentifier:provider.identifier]];
    
    self.dropShadowView.layer.cornerRadius = 2.0f;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.dropShadowView.bounds];
    self.dropShadowView.layer.masksToBounds = NO;
    self.dropShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.dropShadowView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.dropShadowView.layer.shadowOpacity = 0.5f;
    self.dropShadowView.layer.shadowPath = shadowPath.CGPath;
}


# pragma mark - Private

- (NSString *)retrieveProperNameForIdentifier:(NSString *)identifier
{
    NSDictionary *providerNames = @{@"facebook":@"Facebook", @"google":@"Google", @"salesforce":@"Salesforce", @"linkedin":@"LinkedIn", @"enterprise":@"Enterprise", @"qrcode":@"QR Code"};
    
    if ([providerNames.allKeys containsObject:identifier])
    {
        return [providerNames objectForKey:identifier];
    }
    else {
        return identifier;
    }
}

@end
