//
//  ContactsTableViewController.m
//  CloudKitDemo
//
//  Created by Jeff Bailey on 9/21/14.
//  Copyright (c) 2014 FourthFrame. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "UIViewController+FFTUtils.h"

@interface ContactsTableViewController ()

@property (nonatomic, strong) NSArray *userInfoList;
@property (nonatomic) BOOL contactsDiscovered;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.contactsDiscovered = NO;
    [self.cloudService discoverAllContacts:^(NSArray *userInfos, NSError *error) {
        if (!error) {
            
            self.contactsDiscovered = YES;
            self.userInfoList = userInfos;
            [self.tableView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    if (self.contactsDiscovered) {

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
        cell.textLabel.text = NSLocalizedString(@"Discovering contacts...", nil);
        cell.detailTextLabel.text = @"CloudKit can find users of the app from your contacts";
    }
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
