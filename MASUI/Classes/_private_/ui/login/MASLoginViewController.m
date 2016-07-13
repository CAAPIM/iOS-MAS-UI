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


@interface MASLoginViewController ()
    <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, MASLoginWebViewControllerProtocol>

// the original view frame must be used to specify the view's width and height
// whenever appropriate in the "drawLoginDialogWithAuthProviders" implememtation.
@property (nonatomic, assign, readonly) CGRect originalViewFrame;


# pragma mark - IBOutlets

@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *loginBtn;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIImageView *qrCodeView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) MASProximityLoginQRCode *qrCode;

@end


@implementation MASLoginViewController


# pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _originalViewFrame = self.view.frame;
        [self.userNameField setDelegate:self];
        [self.passwordField setDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAuthorizationCodeFromSessionSharing:)
                                                     name:MASDeviceDidReceiveAuthorizationCodeFromProximityLoginNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeQRCode:)
                                                     name:MASProximityLoginQRCodeDidStopDisplayingQRCodeImage
                                                   object:nil];
    }
    
    return self;
}


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
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.userNameField setText:@""];
    [self.passwordField setText:@""];
    
    [self.collectionView reloadData];
    
    [_loginBtn setMultipleTouchEnabled:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (_qrCodeProvider)
    {
        [[MASDevice currentDevice] startAsBluetoothCentralWithAuthenticationProvider:_qrCodeProvider];
        
        if (_qrCode == nil)
        {
            _qrCode = [[MASProximityLoginQRCode alloc] initWithAuthenticationProvider:_qrCodeProvider];
            
            UIImage *qrCodeImage = [_qrCode startDisplayingQRCodeImageForProximityLogin];
            [_qrCodeView setImage:qrCodeImage];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    DLog(@"called");
}


# pragma mark - IBActions

- (IBAction)onLoginSelected:(id)sender
{
    [_loginBtn setEnabled:NO];
    
    //
    // Display an error if device is being authorized through other session sharing method.
    //
    if ([[MASDevice currentDevice] isBeingAuthorized])
    {
        
        NSError *error = [NSError errorWithDomain:MASFoundationErrorDomainLocal code:MASFoundationErrorCodeProximityLoginAuthorizationInProgress userInfo:@{NSLocalizedDescriptionKey : @"Authorization is currently in progress through session sharing."}];
        [UIAlertController popupErrorAlert:error inViewController:self];
    }
    
    
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
    self.basicCredentialsBlock(self.userNameField.text, self.passwordField.text, NO, ^(BOOL completed, NSError *error)
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
                //
                //  Display the alert only for the MAS interface
                //  If the backward compatibility interface and delegate to receive the error message are set, ignore the message
                //
                if ([L7SClientManager delegate] == nil || ![[L7SClientManager delegate] respondsToSelector:@selector(DidReceiveError:)])
                {
                    [UIAlertController popupErrorAlert:error inViewController:blockSelf];
                }
                
                [_loginBtn setEnabled:YES];
            
                return;
            }
            
            //
            // Stop QR Code session sharing
            //
            [_qrCode stopDisplayingQRCodeImageForProximityLogin];
        
            //
            // Dsmiss the view controller
            //
            [blockSelf dismissViewControllerAnimated:YES completion:nil];
        });
    });
}


# pragma mark - Public

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"(%@)\n\n        QR Code Provider: %@\n\n        Authentication Providers:\n\n%@",
        [self class], [self qrCodeProvider], [self authenticationProviders]];
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
    
    self.authorizationCodeBlock(authorizationCode, NO, ^(BOOL completed, NSError *error)
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
                                                           //
                                                           //  Display the alert only for the MAS interface
                                                           //  If the backward compatibility interface and delegate to receive the error message are set, ignore the message
                                                           //
                                                           if ([L7SClientManager delegate] == nil || ![[L7SClientManager delegate] respondsToSelector:@selector(DidReceiveError:)])
                                                           {
                                                               [UIAlertController popupErrorAlert:error inViewController:blockSelf];
                                                           }
                                                           
                                                           return;
                                                       }
                                                       
                                                       //
                                                       // Dsmiss the view controller
                                                       //
                                                       [blockSelf dismissViewControllerAnimated:YES completion:nil];
                                                   });
                                });
}


- (void)removeQRCode:(NSNotification *)notification
{
    _qrCodeView.image = nil;
}


# pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //DLog(@"called for item at indexPath: %@", indexPath);
    
    //
    // Retrieve the authenticatin provider
    //
    MASAuthenticationProvider *provider =[self.authenticationProviders objectAtIndex:indexPath.item];
    
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
        //NSBundle *bundle = [NSBundle bundleForClass:[self class]]; // used for dynamic framework

        NSBundle* bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]URLForResource:@"MASUIResources" withExtension:@"bundle"]]; //Used for Static framework
        
        __block MASLoginWebViewController *viewController = [[MASLoginWebViewController alloc] initWithNibName:@"MASLoginWebViewController" bundle:bundle];
        //[NSBundle masUIFramework]
        
        viewController.authorizationCodeBlock = self.authorizationCodeBlock;
        viewController.delegate = self;
        [viewController setAuthenticationProvider:provider];
        
        //
        // Show the controller
        //
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.authenticationProviders.count;
    
    DLog(@"called and social login providers count: %lu with providers:\n\n%@\n\n",
        (unsigned long)count, self.authenticationProviders);
    
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
    MASAuthenticationProvider *provider =[self.authenticationProviders objectAtIndex:indexPath.item];
    
    //
    // Update the cell
    //
    [cell updateCellWithAuthenticationProvider:provider availableProvider:self.availableProvider];
    
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



# pragma mark - MASLoginWebViewControllerProtocol

- (void)didFinishLoginOnWebView
{
    
    __block MASLoginViewController *blockSelf = self;
    
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
}


@end
