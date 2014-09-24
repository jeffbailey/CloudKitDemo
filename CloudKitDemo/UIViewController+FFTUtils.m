//
//  UIViewController+FFTUtils.m
//  CloudKitDemo
//
//  Created by Jeff Bailey on 9/23/14.
//  Copyright (c) 2014 FourthFrame. All rights reserved.
//

#import "UIViewController+FFTUtils.h"

@implementation UIViewController (FFTUtils)


- (void)presentDefaultAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *act) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
