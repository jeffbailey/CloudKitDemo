//
//  ViewController.m
//  CloudKitDemo
//
//  Created by Jeff Bailey on 9/21/14.
//  Copyright (c) 2014 FourthFrame. All rights reserved.
//

#import "MainViewController.h"

#import "FFTCloudService.h"
#import "ContactsTableViewController.h"
#import "UIViewController+FFTUtils.h"

@interface MainViewController ()

@property (nonatomic, strong) FFTCloudService *cloudService;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cloudService = [FFTCloudService new];
    
    self.welcomeLabel.text = @"";
    self.fullNameLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self.cloudService requestDiscoverabilityPermission:^(CKApplicationPermissionStatus discoverablePermissionStatus, NSError *error) {
        
        switch (discoverablePermissionStatus) {
            case CKApplicationPermissionStatusGranted:
            {
                [self.cloudService discoverUserInfo:^(CKDiscoveredUserInfo *user, NSError *error) {
                    if (error == nil) {
                        [self discoveredUserInfo:user];
                    } else {
                        
                    }
                }];
                break;
            }
            case CKApplicationPermissionStatusDenied:
                [self presentDefaultAlertWithTitle:NSLocalizedString(@"CloudKitDemo", nil) message:NSLocalizedString(@"Getting your name using Discoverability requires permission.", nil) buttonTitle:NSLocalizedString(@"OK", nil)];
                break;
                
            default:
                [self presentDefaultAlertWithTitle:NSLocalizedString(@"CloudKitDemo", nil) message:NSLocalizedString(@"Unable to use CloudKit discovery.  Check the network and if iCloud is enabled for the user.", nil) buttonTitle:NSLocalizedString(@"OK", nil)];
                break;
        }
        
    }];
    
}

- (void)discoveredUserInfo:(CKDiscoveredUserInfo *)user
{
    NSString *userNameText = @"Anonymous";
    
    if (user) {
        userNameText = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    }
    
    [UIView animateWithDuration:0.4f animations:^{
        self.welcomeLabel.text = NSLocalizedString(@"Welcome", nil);
        self.fullNameLabel.text = userNameText;
        
        [self.view layoutIfNeeded];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"findContactsSegue" isEqualToString:segue.identifier]) {
        ContactsTableViewController *contactsTVC = (ContactsTableViewController *)segue.destinationViewController;
        
        contactsTVC.cloudService = self.cloudService;
    }
}



@end
