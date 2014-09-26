//
//  ViewController.m
//  CloudKitDemo
//
//  Created by Jeff Bailey on 9/21/14.
//  Copyright (c) 2014 FourthFrame. All rights reserved.
//

#import "MainViewController.h"

#import "FFTCloudService.h"
#import "DiscoveredContactsTableViewController.h"
#import "UIViewController+FFTUtils.h"

@interface MainViewController ()

@property (nonatomic, strong) FFTCloudService *cloudService;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) CKDiscoveredUserInfo *userInfo;
@property (readonly) NSString *userFullName;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cloudService = [FFTCloudService new];
    
    self.fullNameLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.userInfo) {
        self.fullNameLabel.text = self.userFullName;
        [self.activityIndicator stopAnimating];
    } else {
        [self.activityIndicator startAnimating];
        
        [self.cloudService requestDiscoverabilityPermission:^(CKApplicationPermissionStatus discoverablePermissionStatus, NSError *error) {
            
            [self.activityIndicator stopAnimating];
            
            switch (discoverablePermissionStatus) {
                case CKApplicationPermissionStatusGranted:
                {
                    [self.cloudService discoverUserInfo:^(CKDiscoveredUserInfo *user, NSError *error) {
                        if (error == nil) {
                            [self discoveredUserInfo:user];
                        } else {
                            NSString *errorMsg = [NSString stringWithFormat:@"Error discovering user info: %@", error.localizedDescription];
                            [self presentDefaultAlertWithTitle:NSLocalizedString(@"CloudKitDemo", nil) message:NSLocalizedString(errorMsg, nil) buttonTitle:NSLocalizedString(@"OK", nil)];
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
}

- (void)discoveredUserInfo:(CKDiscoveredUserInfo *)user
{
    self.userInfo = user;
    
    NSString *userNameText = [self userFullName];
    
    [UIView animateWithDuration:0.4f animations:^{
        self.fullNameLabel.text = userNameText;
        
        [self.view layoutIfNeeded];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"findContactsSegue" isEqualToString:segue.identifier]) {
        DiscoveredContactsTableViewController *contactsTVC = (DiscoveredContactsTableViewController *)segue.destinationViewController;
        
        contactsTVC.cloudService = self.cloudService;
    }
}

- (NSString *)userFullName
{
    NSString *userNameText=@"Anonymous";
    if (self.userInfo) {
        userNameText = [NSString stringWithFormat:@"%@ %@", self.userInfo.firstName, self.userInfo.lastName];
    }
    return userNameText;
}




@end
