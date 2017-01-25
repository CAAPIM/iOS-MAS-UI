//
//  MASOTPChannelViewController.m
//  MASUI
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import "MASOTPChannelViewController.h"

#import "MASTableViewCell.h"
#import "UIAlertController+MASUI.h"


@interface MASOTPChannelViewController ()
    <UITableViewDataSource, UITableViewDelegate>

# pragma mark - IBOutlets

/**
 *  Loading indicator
 */
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;


/**
 *  UITableView
 */
@property (nonatomic, weak) IBOutlet UITableView *channelListView;

@end


@implementation MASOTPChannelViewController

# pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_channelListView setEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *firstRowPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_channelListView selectRowAtIndexPath:firstRowPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    DLog(@"called");
}


# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _supportedChannels.count + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";
    MASTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell)
    {
        cell = [[MASTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellID];
    }
    
    if (indexPath.row == _supportedChannels.count)
    {
        cell.textLabel.text = @"Send";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:21.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else if (indexPath.row == _supportedChannels.count + 1)
    {
        cell.textLabel.text = @"Cancel";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:21.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else {
     
        cell.textLabel.text = [_supportedChannels objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _supportedChannels.count || indexPath.row == _supportedChannels.count + 1)
    {
        return NO;
    }
    
    return  YES;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Select OTP Delivery Channel";
}


# pragma mark - Table view delegate

/**
 *  Sends the OTP channels selected to continue the request with OTP channels value.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _supportedChannels.count)
    {
        [self.activityIndicator startAnimating];
        
        NSMutableIndexSet *indicesOfItemsToSelect = [NSMutableIndexSet new];
        if ([[_channelListView indexPathsForSelectedRows] count])
        {
            for (NSIndexPath *selectionIndex in [_channelListView indexPathsForSelectedRows])
            {
                if (selectionIndex.row != _supportedChannels.count)
                {
                    [indicesOfItemsToSelect addIndex:selectionIndex.row];
                }
            }
        }
        
        //
        // Perform the request for selected channels list.
        //
        DLog(@"\n\ncalling otp generation block: %@\n\n", self.otpGenerationBlock);
        
        __block MASOTPChannelViewController *blockSelf = self;
        self.otpGenerationBlock([_supportedChannels objectsAtIndexes:indicesOfItemsToSelect], NO,
        ^(BOOL completed, NSError *error)
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
                    [UIAlertController popupErrorAlert:error inViewController:blockSelf];
                    
                    return;
                }
                                                       
                //
                // Dsmiss the view controller
                //
                [blockSelf dismissViewControllerAnimated:YES completion:nil];
            });
            
        });
    }
    else if (indexPath.row == _supportedChannels.count + 1)
    {
        [self.activityIndicator startAnimating];
        
        __block MASOTPChannelViewController *blockSelf = self;
        self.otpGenerationBlock(nil, YES, ^(BOOL completed, NSError *error) {
        
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

        });
    }
}

@end
