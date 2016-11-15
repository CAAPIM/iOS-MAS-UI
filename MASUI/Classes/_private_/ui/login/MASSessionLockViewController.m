//
//  MASSessionLockViewController.m
//  MASUI
//
//  Created by Hun Go on 2016-10-28.
//  Copyright © 2016 CA Technologies. All rights reserved.
//

#import "MASSessionLockViewController.h"
#import "UIAlertController+MASUI.h"
#import "MASUser+MASUI.h"

@interface MASSessionLockViewController ()

@property (nonatomic, assign) IBOutlet UILabel *userLabel;
@property (assign) BOOL isUnlocking;

@end

@implementation MASSessionLockViewController

# pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unlockSession)];
    [self.view addGestureRecognizer:tapGesture];
    
    _isUnlocking = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self unlockSession];
    [_userLabel setText:[NSString stringWithFormat:@"Logged-in as: %@", [MASUser currentUser].userName]];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


# pragma mark - Private

- (void)unlockSession
{
    if (!_isUnlocking)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _isUnlocking = YES;
            
            [[MASUser currentUser] unlockSessionWithCompletion:^(BOOL completed, NSError *error) {
                
                _isUnlocking = NO;
                
                if (error == nil)
                {
                    
                    //
                    // If unlock was successful, dismiss the view controller
                    //
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        });
    }
}

@end
