//
//  MASOTPViewController.m
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASOTPViewController.h"


@interface MASOTPViewController () <UITextFieldDelegate>

//
// the original view frame must be used to specify the view's width and height
// whenever appropriate in the "drawLoginDialogWithAuthProviders" implememtation.
//
@property (nonatomic, assign, readonly) CGRect originalViewFrame;


# pragma mark - IBOutlets

/**
 *  Loading indicator
 */
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;


/**
 *  OTP error message label.
 */
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;


/**
 *  One Time Password input field.
 */
@property (nonatomic, weak) IBOutlet UITextField *oneTimePasswordField;


/**
 *  One Time Password send button.
 */
@property (nonatomic, weak) IBOutlet UIButton *sendBtn;

@end


@implementation MASOTPViewController

# pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _originalViewFrame = self.view.frame;
        [self.oneTimePasswordField setDelegate:self];
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.messageLabel setText:[_otpError localizedDescription]];
    
    [self.oneTimePasswordField setText:@""];
    
    [_sendBtn setMultipleTouchEnabled:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    DLog(@"called");
}


# pragma mark - IBActions

/**
 *  IBAction - sendBtn 
 *  Sends the OTP entered to continue the request with OTP value.
 *
 *  @param sender
 */
- (IBAction)onSendSelected:(id)sender
{
    //
    // Make sure user has entered OTP.
    //
    NSString *oneTimePassword = _oneTimePasswordField.text;
    NSCharacterSet *whiteSpaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    oneTimePassword = [oneTimePassword stringByTrimmingCharactersInSet:whiteSpaces];
    
    if (!oneTimePassword.length)
    {
        return;
    }
    
    [_sendBtn setEnabled:NO];
    
    [self.activityIndicator startAnimating];
    
    //
    // Make sure the keyboard is closed
    //
    [_oneTimePasswordField resignFirstResponder];
    
    //
    // Perform the request
    //
    DLog(@"\n\ncalling fetch otp credentials block: %@\n\n", _otpCredentialsBlock);
    
    __block MASOTPViewController *blockSelf = self;
    self.otpCredentialsBlock(self.oneTimePasswordField.text, NO, ^(BOOL completed, NSError *error)
    {
        
        DLog(@"\n\nblock callback: %@ or error: %@\n\n", (completed ? @"Yes" : @"No"), [error localizedDescription]);
        
        //
        // Ensure this code runs in the main UI thread
        //
        dispatch_async(dispatch_get_main_queue(), ^
        {
            //
            // Stop progress animation
            //
            [blockSelf.activityIndicator stopAnimating];
                           
            //
            // Handle the error
            //
            if(error)
            {
                               
                [_sendBtn setEnabled:YES];
                               
                return;
            }
                           
            //
            // Dsmiss the view controller
            //
            [blockSelf dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

@end
