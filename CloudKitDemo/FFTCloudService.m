//
//  FFTCloudService.m
//  CloudKitDemo
//
//  Created by Jeff Bailey on 9/21/14.
//  Copyright (c) 2014 FourthFrame. All rights reserved.
//

#import "FFTCloudService.h"

@import CloudKit;

@interface FFTCloudService()

@property (strong, readonly) CKContainer *container;
@property (strong, readonly) CKDatabase *publicDatabase;

@property (strong, nonatomic) CKDiscoveredUserInfo *me;
@property (strong, nonatomic) CKRecordID *myRecordId;
@property (strong, nonatomic) CKRecord *myRecord;

@end

@implementation FFTCloudService

- (id)init {
    self = [super init];
    if (self) {
        _container = [CKContainer defaultContainer];
        _publicDatabase = [_container publicCloudDatabase];
    }
    
    return self;
}


- (void)requestDiscoverabilityPermission:(void (^)(CKApplicationPermissionStatus discoverablePermissionStatus, NSError *error)) completionHandler {
    [self.container requestApplicationPermission:CKApplicationPermissionUserDiscoverability
                               completionHandler:^(CKApplicationPermissionStatus applicationPermissionStatus, NSError *error) {
                                   if (error) {
                                       NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
                                   }
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       completionHandler(applicationPermissionStatus, error);
                                   });
                               }];
}

- (void)discoverUserInfo:(void (^)(CKDiscoveredUserInfo *user, NSError *error))completionHandler {
    
    [self.container fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {
        
        if (error) {
            // In your app, handle this error in an awe-inspiring way.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(nil, error);
            });
            
        } else {
            [self.container discoverUserInfoWithUserRecordID:recordID
                           completionHandler:^(CKDiscoveredUserInfo *user, NSError *error) {
                               if (error) {
                                   // In your app, handle this error deftly.
                                   NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
                               } else {
                                   [self fetchAppUser:user];
                               }
                               dispatch_async(dispatch_get_main_queue(), ^(void){
                                    completionHandler(user, error);
                                });
                           }];
        }
    }];
}

- (void)discoverAllContacts:(void (^)(NSArray *userInfos, NSError *error))completionHandler {
    
    [self.container discoverAllContactUserInfosWithCompletionHandler:^(NSArray *userInfos, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(userInfos, error);
        });
    }];
}


- (void)fetchAppUser:(CKDiscoveredUserInfo *)user
{
    
    void(^fetchedMyRecord)(CKRecord *record, NSError *error) = ^(CKRecord *userRecord, NSError *error) {
        self.myRecord = userRecord;
        
        userRecord[@"firstName"] = self.me.firstName;
        userRecord[@"lastName"] = self.me.lastName;
        [self.publicDatabase saveRecord:userRecord completionHandler:^(CKRecord *record, NSError *error){
            NSLog(@"Saved record ID %@", record.recordID);
        }];
    };
    
    
    self.myRecordId = user.userRecordID;
    if(user) {
        NSLog(@"Me = %@ %@ %@", user.firstName, user.lastName, user.userRecordID.debugDescription);
        
        [self.publicDatabase fetchRecordWithID:self.myRecordId completionHandler:fetchedMyRecord];
    }
    self.me = user;
    
}



@end
