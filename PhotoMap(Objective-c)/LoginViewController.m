//
//  LoginViewController.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 09.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "LoginViewController.h"
@import FirebaseAuth;

@implementation LoginViewController

#pragma mark - ViewControllerLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Action

- (IBAction)signInAction:(UIButton *)sender {
    if(![self validateEditText]){
        return;
    }
    
    [[FIRAuth auth] signInWithEmail:self.emailTextField.text
                           password:self.passwordTextField.text
                         completion:^(FIRUser *user, NSError *error) {
                             if(error) {
                                 [self callAlertControllerWithTitle:@"Error" andWithMessage:@"Inccorect Email or Password"];
                             }else {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }
                         }];
}

- (IBAction)createNewAccAction:(UIButton *)sender {
    if(![self validateEditText]){
        return;
    }
    
    [[FIRAuth auth] createUserWithEmail:self.emailTextField.text
                               password:self.passwordTextField.text
                             completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                                 if(error) {
                                     [self callAlertControllerWithTitle:@"Error" andWithMessage:@"Inccorect Email or Password"];
                                 }else {
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }
                             }];
}

#pragma mark - EditTextsValidation

-(bool) validateEditText {
    
    NSString* email = self.emailTextField.text;
    NSString* password = self.passwordTextField.text;
    
    if([email isEqualToString:@""]){
        [self callAlertControllerWithTitle:@"Error" andWithMessage:@"Email field is Empty"];
        return NO;
    } else if([password isEqualToString:@""]){
        [self callAlertControllerWithTitle:@"Error" andWithMessage:@"Password field is Empty"];
        return NO;
    }
    
    NSRange searchedRange = NSMakeRange(0, [email length]);
    NSString* pattern = @"@([A-Za-z]+).([a-z])";
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    NSArray* array = [regex matchesInString:email options:0 range: searchedRange];

    if (array == nil || [array count] == 0){
        [self callAlertControllerWithTitle:@"Error" andWithMessage:@"Incorrect Email address"];
        return NO;
    } else if([password length] < 6){
        [self callAlertControllerWithTitle:@"Error" andWithMessage:@"Password must contain at least six characters"];
        return NO;
    }
    
    return YES;
}

@end
