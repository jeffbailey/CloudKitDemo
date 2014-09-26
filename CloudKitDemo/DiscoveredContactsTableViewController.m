//
//  ContactsTableViewController.m
//  CloudKitDemo
//
//  Created by Jeff Bailey on 9/21/14.
//  Copyright (c) 2014 FourthFrame. All rights reserved.
//

#import "DiscoveredContactsTableViewController.h"
#import "UIViewController+FFTUtils.h"

@interface DiscoveredContactsTableViewController ()

@property (nonatomic, strong) NSArray *userInfoList;
@property (nonatomic) BOOL contactsDiscovered;

@end

@implementation DiscoveredContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.contactsDiscovered = NO;
    [self.cloudService discoverAllContacts:^(NSArray *userInfos, NSError *error) {
        
        if (!error) {
            
            self.contactsDiscovered = YES;
            self.userInfoList = userInfos;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]  withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else {
            //CKErrorShouldThrottleClient
            NSNumber *retryAfter = [error.userInfo objectForKey:@"CKRetryAfter"];
            if (retryAfter) {
                NSString *rateLimitText = [NSString stringWithFormat:@"Please retry after %d seconds", retryAfter.intValue];
                [self presentDefaultAlertWithTitle:NSLocalizedString(@"CloudKit Rate Limit Exceeded", nil) message:NSLocalizedString(rateLimitText, @"Retry the request after the specified seconds") buttonTitle:NSLocalizedString(@"OK", nil)];
            }
        }
    }];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (self.userInfoList.count > 0 ? self.userInfoList.count:1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (self.contactsDiscovered) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];

        if (self.userInfoList.count) {
            // Configure the cell...
            CKDiscoveredUserInfo *userInfo = self.userInfoList[indexPath.row];

            NSString *fullName = [NSString  stringWithFormat:@"%@ %@", userInfo.firstName, userInfo.lastName];
            cell.textLabel.text = fullName;
            cell.detailTextLabel.text = userInfo.userRecordID.recordName;
        } else {
            cell.textLabel.text = NSLocalizedString(@"No contacts found", nil);
            cell.detailTextLabel.text = @"None of your contacts have run the app";
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"discoveringCell" forIndexPath:indexPath];

    }
    
    return cell;
}

@end
