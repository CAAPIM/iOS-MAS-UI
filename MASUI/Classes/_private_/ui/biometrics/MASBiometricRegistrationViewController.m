//
//  MASBiometricRegistrationViewController.m
//  MASUI
//
//  Copyright (c) 2017 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASBiometricRegistrationViewController.h"

#import "NSBundle+MASUI.h"
#import "MASUIConstantPrivate.h"
#import "UIAlertController+MASUI.h"


@interface MASBiometricRegistrationViewController ()

@property (nonatomic, strong)IBOutlet UITableView *tableView;


/**
 *  Unregistered biometric modalities.
 */
@property (nonatomic, strong)NSMutableArray *tobeRegisteredModalities;


/**
 *  Registered biometric modalities.
 */
@property (nonatomic, strong)NSMutableArray *registeredModalities;


/**
 *  User selected modalities.
 */
@property (nonatomic, strong)NSMutableArray *selectedModalities;

@end


@implementation MASBiometricRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Register Biometrics";
    
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
    //  Formulate the unregistered and registered modality list.
    //
    _tobeRegisteredModalities = [NSMutableArray array];
    _registeredModalities = [NSMutableArray array];
    for (NSDictionary *authenticator in _availableModalities) {
        
        NSNumber *status =
            (NSNumber *)authenticator[MASUIBiometricModalityRegistrationStatusKey];
        if ([status boolValue]) {
            
            [_registeredModalities addObject:authenticator];
        }
        else {
            
            [_tobeRegisteredModalities addObject:authenticator];
        }
    }
    
    _selectedModalities = [NSMutableArray array];
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_registeredModalities.count) {
            
        return 2;
    }
        
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = _tobeRegisteredModalities.count;
    
    if (section == 1) {
        
        count = _registeredModalities.count;
    }
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    
    NSString *authenticatorTitle;
    NSString *authenticatorIconName;
    switch (indexPath.section) {
        case 0:
            
            authenticatorTitle = [_tobeRegisteredModalities objectAtIndex:indexPath.row][MASUIBiometricModalityTitleKey];
            authenticatorIconName = [authenticatorTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
            authenticatorIconName = [[authenticatorIconName lowercaseString] stringByAppendingString:@"_enabled"];
            
            break;
            
        case 1:
            
            authenticatorTitle = [_registeredModalities objectAtIndex:indexPath.row][MASUIBiometricModalityTitleKey];
            authenticatorIconName = [authenticatorTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
            authenticatorIconName = [[authenticatorIconName lowercaseString] stringByAppendingString:@"_disabled"];
            
            break;
            
        default:
            break;
    }
    
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
    
    NSString *title = @"Register Modalities";
    
    if (section == 1) {
        
        title = @"Registered Modalities";
    }
    
    return title;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            
            cell.userInteractionEnabled = YES;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            cell.editing = YES;
            
            break;
            
        case 1:
            
            cell.userInteractionEnabled = NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor lightGrayColor];
            
            cell.editing = NO;
            
            break;
            
        default:
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[tableView indexPathsForSelectedRows] count] > 1) {
        
        //
        //  Stub to remove multi selection mode.
        //
        for (NSIndexPath *index in [tableView indexPathsForSelectedRows]) {
            
            if (index.row != indexPath.row) {
                
                [self.tableView deselectRowAtIndexPath:index animated:YES];
                
                NSString *modality;
                if (index.section == 0)
                    modality = [_tobeRegisteredModalities objectAtIndex:index.row];
                else if (index.section == 1)
                    modality = [_registeredModalities objectAtIndex:index.row];
                
                if ([_selectedModalities containsObject:modality])
                    [_selectedModalities removeObject:modality];
            }
        }
    }
    
    NSString *modality;
    if (indexPath.section == 0)
        modality = [_tobeRegisteredModalities objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        modality = [_registeredModalities objectAtIndex:indexPath.row];
    
    if ([_tobeRegisteredModalities containsObject:modality])
        [_selectedModalities addObject:modality];
}


#pragma mark - Actions

- (IBAction)doneAction:(id)sender {
    
    __block MASBiometricRegistrationViewController *blockSelf = self;
    
    //
    // Ensure this code runs in the main UI thread
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_selectedModalities.count) {
            
            //
            // Dsmiss the view controller
            //
            [blockSelf dismissRegistrationViewControllerAnimated:YES completion:^{
                
                if (_completionBlock) {
                    
                    _completionBlock(_selectedModalities, NO, nil);
                }
                
                return;
            }];
        }
        else {
            
            NSError *error = [NSError errorForUIErrorCode:MASUIErrorCodeNothingSelected errorDomain:kSDKErrorDomain];
            
            [UIAlertController popupErrorAlert:error inViewController:blockSelf];
            
            return ;
        }
    });
}


- (IBAction)cancelAction:(id)sender {
    
    __block MASBiometricRegistrationViewController *blockSelf = self;
    
    //
    // Ensure this code runs in the main UI thread
    //
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [blockSelf dismissRegistrationViewControllerAnimated:YES completion:^{
            
            if (_completionBlock) {
                
                _completionBlock(nil, YES, nil);
            }            
            
            return;
        }];
    });
}


- (void)dismissRegistrationViewControllerAnimated:(BOOL)animated completion: (void (^)(void))completion
{
    [self dismissViewControllerAnimated:animated completion:completion];
}

@end
