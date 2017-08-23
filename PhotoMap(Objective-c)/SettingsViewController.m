//
//  SettingsViewController.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 14.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "NVSettingsModel.h"
#import "MapUiViewController.h"
#import "NVConst.h"

bool changeSettingsIndicator = NO;
bool changeSettingsIndicatorForTimeLine = NO;
@interface SettingsViewController ()
@property(strong,nonatomic) NSArray *arrayOfSettingsData;
@property(strong,nonatomic) NSUserDefaults *userSettings;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arrayOfSettingsData = [self putSettingsDataToArray];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
                                                                                              forKey:NSForegroundColorAttributeName];
    self.userSettings = [NSUserDefaults standardUserDefaults];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Settings Data

-(NSArray*)putSettingsDataToArray {
    NVSettingsModel *modelNature = [NVSettingsModel new];
    NVSettingsModel *modelFriends  = [NVSettingsModel new];
    NVSettingsModel *modelDefault  = [NVSettingsModel new];
    
    modelNature.idOfSetting = 0;
    modelNature.nameOfSetting = TypeOfPhotoNature;
    modelNature.colorOfSetting = @"#578E18";
    
    modelFriends.idOfSetting = 1;
    modelFriends.nameOfSetting = TypeOfPhotoFriends;
    modelFriends.colorOfSetting = @"#F4A523";
    
    modelDefault.idOfSetting = 2;
    modelDefault.nameOfSetting = TypeOfPhotoDefault;
    modelDefault.colorOfSetting = @"#368EDF";

    
    return [NSArray arrayWithObjects:modelNature,modelFriends,modelDefault, nil];
}

#pragma mark - Convert Color

- (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [self colorWithHex:x];
}
- (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfSettingsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* identifire = @"settingsCell";
    
    SettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    
    if(!cell){
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
    }
    
    NVSettingsModel *model = [self.arrayOfSettingsData objectAtIndex:indexPath.row];
    
    UIColor *color = [self colorWithHexString:model.colorOfSetting];
    
    bool settingsStatus = [self.userSettings boolForKey:model.nameOfSetting];
    
    if(settingsStatus){
        [cell.settingsButton setTintColor:color];
        [cell.settingsButton setBackgroundColor:color];
    } else{
        [cell.settingsButton setTintColor:[UIColor clearColor]];
        [cell.settingsButton setBackgroundColor:[UIColor clearColor]];
    }    
  
    [cell.settingsButton.layer setBorderColor:color.CGColor];
    [cell.settingsButton.layer setCornerRadius:25.f];
    [cell.settingsButton.layer setBorderWidth:1.f];
    
    cell.settingsLabel.text = [model.nameOfSetting uppercaseString];
    cell.settingsLabel.textColor = color;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NVSettingsModel *model = [self.arrayOfSettingsData objectAtIndex:indexPath.row];
    bool settingsStatus = [self.userSettings boolForKey:model.nameOfSetting];
    
    if(settingsStatus){
        [self.userSettings setBool:NO forKey:model.nameOfSetting];
    } else{
        [self.userSettings setBool:YES forKey:model.nameOfSetting];
    }
    
    changeSettingsIndicator = YES;
    changeSettingsIndicatorForTimeLine = YES;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
