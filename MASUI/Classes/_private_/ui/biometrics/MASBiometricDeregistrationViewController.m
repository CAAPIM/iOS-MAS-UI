//
//  MASBiometricDeregistrationViewController.m
//  MASUI
//
//  Copyright (c) 2017 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASBiometricDeregistrationViewController.h"

#import "NSBundle+MASUI.h"
#import "MASUIConstantPrivate.h"
#import "UIAlertController+MASUI.h"


@interface MASBiometricDeregistrationViewController ()

@property (nonatomic, strong)IBOutlet UITableView *tableView;


/**
 *  Registered biometric modalities.
 */
@property (nonatomic, strong)NSMutableArray *tobeDeregisteredModalities;


/**
 *  User selected biometric modalities.
 */
@property (nonatomic, strong)NSMutableArray *selectedModalities;

@end


@implementation MASBiometricDeregistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Deregister";
    
    //
    //  Enable UITableView editing with Multiple selection.
    //
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    
    [_tableView setEditing:YES animated:YES];
    
    //
    // Selection Actions
    //
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self action:@selector(doneAction:)];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self action:@selector(cancelAction:)];
    
    //
    //  Formulate registered modality list.
    //
    _tobeDeregisteredModalities = [NSMutableArray array];
    for (NSDictionary *authenticator in _availableModalities) {
        
        NSNumber *regStatus =
            authenticator[MASUIBiometricModalityRegistrationStatusKey];
        if ([regStatus boolValue]) {
            
            [_tobeDeregisteredModalities addObject:authenticator];
        }
    }
    
    _selectedModalities = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIBarButtonItem *flexItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *deregisterAllButton =
        [[UIBarButtonItem alloc] initWithTitle:@"Deregister All" style:UIBarButtonItemStylePlain
                                        target:self action:@selector(deregisterAll:)];
    
    [self setToolbarItems:[NSArray arrayWithObjects:flexItem, deregisterAllButton, flexItem, nil]];
    
    self.navigationController.toolbarHidden = NO;
    
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [self setToolbarItems:nil];
    
    self.navigationController.toolbarHidden = YES;
    
    [super viewWillDisappear:animated];
}


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _tobeDeregisteredModalities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    
    NSString *authenticatorTitle =
        [_tobeDeregisteredModalities objectAtIndex:indexPath.row][MASUIBiometricModalityTitleKey];
    
    NSString *authenticatorIconName =
        [authenticatorTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    authenticatorIconName = [[authenticatorIconName lowercaseString] stringByAppendingString:@"_enabled"];
    
    cell.textLabel.text = authenticatorTitle;
    
    NSBundle *bundle = [NSBundle masUIFramework];
    NSString *imagePath = [bundle pathForResource:authenticatorIconName ofType:@"png"];
    cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 66.0f;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Deregister Modalities";
}


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.userInteractionEnabled = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    cell.editing = YES;            
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    //  Adding selected modality.
    //
    NSString *modality = [_tobeDeregisteredModalities objectAtIndex:indexPath.row];        
    if ([_tobeDeregisteredModalities containsObject:modality])
        [_selectedModalities addObject:modality];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    //  Removing selected modality.
    //
    NSString *modality = [_tobeDeregisteredModalities objectAtIndex:indexPath.row];
    if ([_tobeDeregisteredModalities containsObject:modality])
        [_selectedModalities removeObject:modality];
}


#pragma mark - Actions

- (IBAction)doneAction:(id)sender {
    
    __block MASBiometricDeregistrationViewController *blockSelf = self;
    
    //
    // Ensure this code runs in the main UI thread
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_selectedModalities.count) {
            
            //
            // Dsmiss the view controller
            //
            [blockSelf dismissDeregistrationViewControllerAnimated:YES completion:^{
                
                if (_completionBlock) {
                    
                    _completionBlock(_selectedModalities, NO, nil);
                }
                
                return;
            }];
        }
        else {
            
            NSError *error =
                [NSError errorForUIErrorCode:MASUIErrorCodeNothingSelected errorDomain:kSDKErrorDomain];
            
            [UIAlertController popupErrorAlert:error inViewController:blockSelf];
            
            return ;
        }
    });
}


- (IBAction)cancelAction:(id)sender {
    
    __block MASBiometricDeregistrationViewController *blockSelf = self;
    
    //
    // Ensure this code runs in the main UI thread
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [blockSelf dismissDeregistrationViewControllerAnimated:YES completion:^{
            
            if (_completionBlock) {
                
                _completionBlock(nil, YES, nil);
            }
            
            return;
        }];
    });
}


- (IBAction)deregisterAll:(id)sender {
    
    _selectedModalities = _tobeDeregisteredModalities;
    
    [self doneAction:sender];
}

- (void)dismissDeregistrationViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion
{    
    [self dismissViewControllerAnimated:animated completion:completion];
}

@end
