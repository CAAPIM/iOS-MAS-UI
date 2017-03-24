//
//  MASLoginQRCodeView.h
//  MASUI
//
//  Created by Hun Go on 2017-03-23.
//  Copyright © 2017 CA Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MASLoginQRCodeView : UIView

- (void)displayQRCodeWithProvider:(MASAuthenticationProvider *)provider;

@end
