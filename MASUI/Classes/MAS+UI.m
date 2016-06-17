//
//  MAS+UI.m
//  MASUI
//
//  Copyright (c) 2016 CA, Inc.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MAS+UI.h"

#import "MASUIService.h"


@implementation MAS (UI)


# pragma mark - Authentication Handling

+ (BOOL)willHandleAuthentication
{
    return [MASUIService willHandleAuthentication];
}


+ (void)setWillHandleAuthentication:(BOOL)handle
{
    [MASUIService setWillHandleAuthentication:handle];
}


+ (BOOL)willHandleOTPAuthentication
{
    return [MASUIService willHandleOTPAuthentication];
}


+ (void)setWillHandleOTPAuthentication:(BOOL)handle
{
    [MASUIService setWillHandleOTPAuthentication:handle];
}

@end
