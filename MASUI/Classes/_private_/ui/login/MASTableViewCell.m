//
//  MASTableViewCell.m
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASTableViewCell.h"


@implementation MASTableViewCell


# pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self.contentView.layer setCornerRadius:5.0];
    }
    
    return self;
}


# pragma mark - Properties

+ (CGFloat)cellHeight
{
    return 45.0;
}


+ (NSString *)cellId
{
    return nil;
}

@end
