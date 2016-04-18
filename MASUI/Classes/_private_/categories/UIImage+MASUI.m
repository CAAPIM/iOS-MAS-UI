//
//  UIImage+MASUI.m
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "UIImage+MASUI.h"

#import "NSBundle+MASUI.h"


@implementation UIImage (MASUI)


# pragma mark - Bundle Images

+ (UIImage *)masUIAuthenticationProviderImageForKey:(NSString *)key enabled:(BOOL)enabled
{
    NSString *imageName = (enabled ? key : [NSString stringWithFormat:@"%@_disable", key]);
    
    return [self masUIImageNamed:imageName];
}


+ (UIImage *)masUIImageNamed:(NSString *)imageName
{
    //NSBundle *bundle = [NSBundle bundleForClass:[self class]]; //Used for dynamic framework
    
    NSBundle* bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]URLForResource:@"MASUIResources" withExtension:@"bundle"]]; //Used for Static framework
//    return [UIImage imageNamed:[NSString stringWithFormat:@"MASUIResources.dundle/%@",imageName]];
    return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    //[NSBundle masUIFramework]
}
    
@end
