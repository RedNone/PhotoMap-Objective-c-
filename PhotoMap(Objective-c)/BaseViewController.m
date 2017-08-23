//
//  BaseViewController.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 10.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - CallAlertController

- (void)callAlertControllerWithTitle:(NSString *)title andWithMessage:(NSString *)message {
    
    UIAlertController* alert=   [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
