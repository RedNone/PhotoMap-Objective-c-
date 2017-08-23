#import "MoreViewController.h"
@import FirebaseAuth;
@interface MoreViewController ()

@end

@implementation MoreViewController



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"User Account Settings";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* identifire = @"logOutCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"Log Out";
    
    
    return cell;
}

#pragma mark - UITableViewDelegat

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        [self callAlertControllerWithTitle:@"Error" andWithMessage:@"Cannot signing out"];
        return;
    } else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
