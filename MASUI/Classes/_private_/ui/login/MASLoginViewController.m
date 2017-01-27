//
//  MASLoginViewController.m
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASLoginViewController.h"

#import "MASAuthenticationProviderCollectionViewCell.h"
#import "MASICenterFlowLayout.h"
#import "MASLoginWebViewController.h"
#import "NSBundle+MASUI.h"
#import "UIAlertController+MASUI.h"
#import "UIImage+MASUI.h"

#import <SafariServices/SafariServices.h>


@interface MASLoginViewController ()
    <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, MASAuthorizationResponseDelegate>

# pragma mark - IBOutlets

@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;
@property (nonatomic, weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *qrCodeView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) MASProximityLoginQRCode *qrCode;

@end


@implementation MASLoginViewController


# pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //
    // CollectionView
    //
    MASICenterFlowLayout *layout = [MASICenterFlowLayout new];
    layout.minimumInteritemSpacing = 10.f;
    layout.minimumLineSpacing = 10.f;

    [self.collectionView setCollectionViewLayout:layout animated:NO];
    [self.collectionView registerClass:[MASAuthenticationProviderCollectionViewCell class]
        forCellWithReuseIdentifier:[MASAuthenticationProviderCollectionViewCell cellId]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAuthorizationCodeFromSessionSharing:)
                                                 name:MASDeviceDidReceiveAuthorizationCodeFromProximityLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeQRCode:)
                                                 name:MASProximityLoginQRCodeDidStopDisplayingQRCodeImage
                                               object:nil];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    DLog(@"called");
}


# pragma mark - public

- (void)viewWillReload
{
    [super viewWillReload];
    
    [self.userNameField setText:@""];
    [self.passwordField setText:@""];
    
    [self.collectionView reloadData];
    
    [_loginBtn setMultipleTouchEnabled:NO];
    
    [_loginBtn setEnabled:YES];
    [_cancelBtn setEnabled:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewDidReload
{
    [super viewDidReload];
    
    if (self.proximityLoginProvider)
    {
        [[MASDevice currentDevice] startAsBluetoothCentralWithAuthenticationProvider:self.proximityLoginProvider];
        
        if (_qrCode == nil)
        {
            _qrCode = [[MASProximityLoginQRCode alloc] initWithAuthenticationProvider:self.proximityLoginProvider];
            
            UIImage *qrCodeImage = [_qrCode startDisplayingQRCodeImageForProximityLogin];
            [_qrCodeView setImage:qrCodeImage];
        }
    }
}


- (void)cancel
{
    [super cancel];
}

# pragma mark - IBActions

- (IBAction)onCancelSelected:(id)sender
{
    
    [self.activityIndicator startAnimating];
    
    //
    // Perform the request
    //
    DLog(@"\n\ncalling basic credentials block: %@\n\n", self.basicCredentialsBlock);
    
    __block MASLoginViewController *blockSelf = self;
    
    //
    // Ensure this code runs in the main UI thread
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //
        // Stop progress animation
        //
        [blockSelf.activityIndicator stopAnimating];
        
        //
        // Stop QR Code session sharing
        //
        [_qrCode stopDisplayingQRCodeImageForProximityLogin];
        
        //
        // Cancel the operation
        //
        [self cancel];
    });
}


- (IBAction)onLoginSelected:(id)sender
{
    [_loginBtn setEnabled:NO];
    [_cancelBtn setEnabled:NO];
    
    [self.activityIndicator startAnimating];
    
    //
    // Make sure the keyboard is closed
    //
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    //
    // Perform the request
    //
    DLog(@"\n\ncalling basic credentials block: %@\n\n", self.basicCredentialsBlock);
    
    __block MASLoginViewController *blockSelf = self;
    
    [self loginWithUsername:self.userNameField.text password:self.passwordField.text completion:^(BOOL completed, NSError *error) {
        
        //
        // Ensure this code runs in the main UI thread
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //
            // Stop progress animation
            //
            [blockSelf.activityIndicator stopAnimating];
            
            //
            // Handle the error
            //
            if(error)
            {
                [_loginBtn setEnabled:YES];
                [_cancelBtn setEnabled:YES];
                
                [UIAlertController popupErrorAlert:error inViewController:blockSelf];
                
                return;
            }
            
            //
            // Stop QR Code session sharing
            //
            [_qrCode stopDisplayingQRCodeImageForProximityLogin];
            
            //
            // Dsmiss the view controller
            //
            [self dismissLoginViewControllerAnimated:YES completion:nil];
        });
    }];
}


# pragma mark - Public

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"(%@)\n\n        QR Code Provider: %@\n\n        Authentication Providers:\n\n%@",
        [self class], [self proximityLoginProvider], [self socialLoginAuthenticationProviders]];
}


# pragma mark - Private

- (void)didReceiveAuthorizationCodeFromSessionSharing:(NSNotification *)notification
{
    __block MASLoginViewController *blockSelf = self;
    
    NSString *authorizationCode = [notification.object objectForKey:@"code"];
    
    //
    // Stop QR Code session sharing
    //
    [_qrCode stopDisplayingQRCodeImageForProximityLogin];
    
    //
    // Start activity indicator
    //
    [self.activityIndicator startAnimating];
    
    [self loginWithAuthorizationCode:authorizationCode completion:^(BOOL completed, NSError *error) {
       
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
                               [UIAlertController popupErrorAlert:error inViewController:blockSelf];
                               
                               return;
                           }
                           
                           //
                           // Dsmiss the view controller
                           //
                           [blockSelf dismissLoginViewControllerAnimated:YES completion:nil];
                       });
    }];
}


- (void)removeQRCode:(NSNotification *)notification
{
    _qrCodeView.image = nil;
    _qrCode = nil;
}


# pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //DLog(@"called for item at indexPath: %@", indexPath);
    
    //
    // Retrieve the authenticatin provider
    //
    MASAuthenticationProvider *provider =[self.socialLoginAuthenticationProviders objectAtIndex:indexPath.item];
    
    //
    // Check if selected provider is available
    //
    if (![[self.availableProvider lowercaseString] isEqualToString:@"all"] && ![provider.identifier isEqualToString:self.availableProvider])
    {
        //
        // If not all is available and the selected one is not the one that is available, skip
        //
        return;
    }
    
    //
    // if the authentication provider exists 
    //
    if (provider)
    {
        SFSafariViewController *viewController = [[SFSafariViewController alloc] initWithURL:provider.authenticationUrl];
        [[MASAuthorizationResponse sharedInstance] setDelegate:self];
        
        //
        // Show the controller
        //
        [self.navigationController presentViewController:viewController animated:YES completion:nil];
    }
}


# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.socialLoginAuthenticationProviders.count;
    
    DLog(@"called and social login providers count: %lu with providers:\n\n%@\n\n",
        (unsigned long)count, self.socialLoginAuthenticationProviders);
    
    return count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //DLog(@"called for item at indexPath: %@", indexPath);
    
    //
    // Retreive the cell
    //
    MASAuthenticationProviderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MASAuthenticationProviderCollectionViewCell cellId] forIndexPath:indexPath];
    if(!cell)
    {
        DLog(@"\n\nWarning no collection view cell was returned\n\n");
        
        return nil;
    }
    
    //
    // Retrieve the authenticatin provider
    //
    MASAuthenticationProvider *provider =[self.socialLoginAuthenticationProviders objectAtIndex:indexPath.item];
    
    //
    // Update the cell
    //
    [cell updateCellWithAuthenticationProvider:provider availableProvider:self.availableProvider];
    cell.accessibilityIdentifier = [NSString stringWithFormat:@"masui-sociallogin-%@",provider.identifier];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //DLog(@"called for item at indexPath: %@", indexPath);
    
    return [MASAuthenticationProviderCollectionViewCell cellSize];
}



# pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //
    // if it was finished on password, submit login information
    //
    if ([textField isEqual:_passwordField])
    {
        [self onLoginSelected:nil];
    }
    else if ([textField isEqual:_userNameField]){
        [_passwordField becomeFirstResponder];
    }
    
    return YES;
}



# pragma mark - MASAuthorizationResponseDelegate

- (void)didReceiveError:(NSError *)error
{
    //
    // Display the error
    //
    [UIAlertController popupErrorAlert:error inViewController:self];
    
    //
    // Dismiss SFViewController
    //
    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveAuthorizationCode:(NSString *)code
{
    //
    // Dismiss SFViewController
    //
    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
    
    //
    // Start animating activity indicator
    //
    [self.activityIndicator startAnimating];
    
    __block MASLoginViewController *blockSelf = self;
    
    [self loginWithAuthorizationCode:code completion:^(BOOL completed, NSError *error) {
        
        //
        // Stop progress animation
        //
        [blockSelf.activityIndicator stopAnimating];
        
        //
        // Handle the error
        //
        if(error)
        {
            [UIAlertController popupErrorAlert:error inViewController:blockSelf];
            
            return;
        }
        
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
                           // Dsmiss the view controller
                           //
                           [blockSelf dismissViewControllerAnimated:YES completion:nil];
                       });
    }];
}

@end
