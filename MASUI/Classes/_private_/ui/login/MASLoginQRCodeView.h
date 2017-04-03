//
//  MASLoginQRCodeView.h
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>

@interface MASLoginQRCodeView : UIView

- (void)displayQRCodeWithProvider:(MASAuthenticationProvider *)provider;

@end
