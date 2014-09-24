//
//  ContactsTableViewController.h
//  CloudKitDemo
//
//  Created by Jeff Bailey on 9/21/14.
//  Copyright (c) 2014 FourthFrame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFTCloudService.h"

@interface ContactsTableViewController : UITableViewController

@property (nonatomic, strong) FFTCloudService *cloudService;


@end
