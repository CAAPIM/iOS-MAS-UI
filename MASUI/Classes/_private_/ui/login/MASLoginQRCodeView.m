//
//  MASLoginQRCodeView.m
//  MASUI
//
//  Created by Hun Go on 2017-03-23.
//  Copyright © 2017 CA Technologies. All rights reserved.
//

#import "MASLoginQRCodeView.h"

#import "NSBundle+MASUI.h"

@interface MASLoginQRCodeView ()

@property (nonatomic, weak) IBOutlet UIImageView *qrCodeImageView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, strong) MASProximityLoginQRCode *qrCode;

@end

@implementation MASLoginQRCodeView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupView];
        
        self.contentView.layer.cornerRadius = 2.0f;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
        self.contentView.layer.masksToBounds = NO;
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
        self.contentView.layer.shadowOpacity = 0.5f;
        self.contentView.layer.shadowPath = shadowPath.CGPath;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeQRCode:)
                                                     name:MASProximityLoginQRCodeDidStopDisplayingQRCodeImage
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeQRCode:)
                                                     name:MASDeviceDidReceiveAuthorizationCodeFromProximityLoginNotification
                                                   object:nil];
    }
    
    return self;
}


- (void)setupView
{
    UIView *view = [self viewFromNibForClass];
    view.frame = self.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:view];
}


- (UIView *)viewFromNibForClass
{
    NSBundle *bundle = [NSBundle masUIFramework];
    
    UINib *thisNib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:bundle];
    UIView *thisView = [thisNib instantiateWithOwner:self options:nil][0];
    
    return thisView;
}


- (void)displayQRCodeWithProvider:(MASAuthenticationProvider *)provider
{
    _qrCode = [[MASProximityLoginQRCode alloc] initWithAuthenticationProvider:provider];
    
    UIImage *qrCodeImage = [_qrCode startDisplayingQRCodeImageForProximityLogin];
    [_qrCodeImageView setImage:qrCodeImage];
}


- (IBAction)closeView:(id)sender
{
    [_qrCode stopDisplayingQRCodeImageForProximityLogin];
    
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self removeFromSuperview]; }
                    completion:nil];
}


- (void)removeQRCode:(NSNotification *)notification
{
    [UIView transitionWithView:self
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self removeFromSuperview]; }
                    completion:nil];
}

@end
