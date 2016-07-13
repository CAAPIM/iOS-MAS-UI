//
//  NSBundle+MASUI.m
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "NSBundle+MASUI.h"


@implementation NSBundle (MASUI)

static NSBundle *_masUIFramework__;


+ (NSBundle *)masUIFramework
{
    if(!_masUIFramework__)
    {
        _masUIFramework__ = [NSBundle bundleWithIdentifier:@"com.ca.MASUI"];
    }
    
    return _masUIFramework__;
}

@end
