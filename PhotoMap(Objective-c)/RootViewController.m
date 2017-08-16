//
//  RootViewController.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 09.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "RootViewController.h"
#import "NVSingletonFireBaseManager.h"
@import FirebaseAuth;

@implementation RootViewController


-(void)viewDidAppear:(BOOL)animated {
    if([[FIRAuth auth] currentUser] == nil){
        [self performSegueWithIdentifier:@"segueLoginScreen" sender:self];
    } else {
        [[NVSingletonFireBaseManager sharedManager] downloadData];
        [self performSegueWithIdentifier:@"segueTabBarScreen" sender:self];
    }
}

@end
