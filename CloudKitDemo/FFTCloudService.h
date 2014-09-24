//
//  FFTCloudService.h
//  CloudKitDemo
//
//  Created by Jeff Bailey on 9/21/14.
//  Copyright (c) 2014 FourthFrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CloudKit;


@interface FFTCloudService : NSObject

- (void)requestDiscoverabilityPermission:(void (^)(CKApplicationPermissionStatus discoverablePermissionStatus, NSError *error)) completionHandler;

- (void)discoverUserInfo:(void (^)(CKDiscoveredUserInfo *user, NSError *error))completionHandler;


- (void)discoverAllContacts:(void (^)(NSArray *userInfos, NSError *error))completionHandler;

@end
