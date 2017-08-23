#import "TimeLineTableViewCell.h"
#import "TimeLineViewController.h"
#import "NVTimeLineDataController.h"
#import "NVConst.h"
#import "NVSingletonFireBaseManager.h"
#import "NVTimeLineDataModel.h"
#import "UIImage+NVConvertImageExtension.h"
#import "TimeLineTableSections.h"
#import "FullPhotoViewController.h"
#import "SettingsViewController.h"

@interface TimeLineViewController ()
@property(nonatomic,strong) UISearchController *searchController;
@property(nonatomic,strong) NVTimeLineDataController *controller;

@end

@implementation TimeLineViewController 

#pragma mark - ViewController LifeCicle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataCome:)
                                                 name:FirebaseManagerDataComeNotification
                                               object:nil];
   
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    
    self.searchController.hidesNavigationBarDuringPresentation = false;
    self.searchController.dimsBackgroundDuringPresentation = false;
    
    self.searchController.searchBar.frame = CGRectMake(8, 0,self.navigationController.navigationBar.frame.size.width*0.70 , self.navigationController.navigationBar.frame.size.height);
    
    [self.navigationController.navigationBar addSubview: self.searchController.searchBar ];

    self.definesPresentationContext = true;
    
    
    UINib *cellNib = [UINib nibWithNibName:@"CustomSectionForTimeLine" bundle:nil];
    [self.tableView registerNib:cellNib forHeaderFooterViewReuseIdentifier:@"sectionOfTable"];
    
}

-(void)dealloc {
    [self.searchController.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.searchController.searchBar setHidden:NO];
    
    
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                      forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor colorWithWhite:0.97f alpha:0.8];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.f green:0.48f blue:1.f alpha:1.f];

    NSMutableArray *array = [[NVSingletonFireBaseManager sharedManager] userData];
    if([[NVSingletonFireBaseManager sharedManager] isDataComeFlagForTimeLine]){
        self.controller = [[NVTimeLineDataController alloc] initWithArray:array];
        [NVSingletonFireBaseManager sharedManager].isDataComeFlagForTimeLine = NO;
        [self.tableView reloadData];
        [self hideProgressBarAndShowTableView];
    } else{
        if(changeSettingsIndicatorForTimeLine){
                if(array || array.count){
                    self.controller = [[NVTimeLineDataController alloc] initWithArray:array];
                    [self.tableView reloadData];
                }
        }
            changeSettingsIndicatorForTimeLine = NO;
    }

}

- (void)userDataCome:(NSNotification *)notification{
    self.controller = [[NVTimeLineDataController alloc] initWithArray:[[NVSingletonFireBaseManager sharedManager] userData]];
    [self.tableView reloadData];
    [NVSingletonFireBaseManager sharedManager].isDataComeFlagForTimeLine = NO;
    [self hideProgressBarAndShowTableView];
}

- (void)hideProgressBarAndShowTableView{
    if(![self.progressIndicator isHidden]){
        self.progressIndicator.hidden = YES;
        self.tableView.hidden = NO;
    }
}

#pragma mark - UISearchDelegete 
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.3f animations:^{
        self.categoryButton.alpha = 0;
    }];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if([searchController.searchBar.text isEqualToString:@""]){
        [self.controller getFullArray];
        [self.tableView reloadData];
        return;
    }

    if(self.controller){
        [self.controller findMathesInArrayWithString:searchController.searchBar.text];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.3f animations:^{
        self.searchController.searchBar.frame = CGRectMake(8, 0,self.navigationController.navigationBar.frame.size.width*0.70 , self.navigationController.navigationBar.frame.size.height);
        self.categoryButton.alpha = 1;
    }];
    if(self.controller){
        [self.controller getFullArray];
        [self.tableView reloadData];
    }
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.3f animations:^{
     self.categoryButton.alpha = 0;
    }];   
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self.controller.arrayForTableView count]){
        self.statusLabel.hidden = YES;
    } else{
         self.statusLabel.hidden = NO;
    }
    return [self.controller.arrayForTableView count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = [self.controller.arrayForTableView objectAtIndex:section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* identifire = @"mainContent";
    
    NVTimeLineDataModel *model = [[self.controller.arrayForTableView objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
   
    TimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];  
  
    cell.descriptionOfPhoto.text = model.model.text;
    cell.typeOfPhotoLabel.text = model.model.type;
    cell.imageView.image = [[UIImage imageWithContentsOfFile:model.model.photoPath] scaledToSize:CGSizeMake(62, 69)];
    cell.dateLabel.text = model.model.date;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString* identifire = @"sectionOfTable";
    
    NVTimeLineDataModel *model = [[self.controller.arrayForTableView objectAtIndex:section] objectAtIndex:0];
    
    TimeLineTableSections *sectionOfTable = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifire];

    sectionOfTable.sectionLabelForTimeLine.text = model.titleOfSection;
        
    return sectionOfTable;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FullPhotoViewController *fullPhotoViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FullPhotoScreen"];
    NVTimeLineDataModel *model = [[self.controller.arrayForTableView objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    fullPhotoViewController.model = [[[NVSingletonFireBaseManager sharedManager] userData] objectAtIndex:model.model.photoId];
    self.searchController.searchBar.hidden = YES;
    [self.navigationController pushViewController:fullPhotoViewController animated:YES];
}

#pragma mark - Button Action

- (IBAction)categoryButtonAction:(UIButton *)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsViewController *settingsViewController = [storyBoard instantiateViewControllerWithIdentifier:@"settingView"];
   
    self.searchController.searchBar.hidden = YES;
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
