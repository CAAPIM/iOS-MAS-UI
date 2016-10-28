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

@end

@implementation MASSessionLockViewController

# pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

# pragma mark - IBAction

- (IBAction)onUnlockSessionSelected:(id)sender
{
    [[MASUser currentUser] unlockSessionWithCompletion:^(BOOL completed, NSError *error) {
       
        if (error != nil)
        {
            //
            // Present error message
            //
            __block MASSessionLockViewController *blockSelf = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIAlertController popupErrorAlert:error inViewController:blockSelf];
            });
        }
        else {
            
            //
            // If unlock was successful, dismiss the view controller
            //
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}


- (IBAction)onDifferentCredentialSelected:(id)sender
{
    //
    // Remove the current session lock
    //
    [[MASUser currentUser] removeSessionLock];
    
    //
    // Dismiss the current view controller, and present login view controller
    //
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [MASUser presentLoginViewControllerWithCompletion:nil];
        });
    }];
}

@end
