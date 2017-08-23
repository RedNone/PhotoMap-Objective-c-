//
//  TimeLineViewController.h
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 09.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TimeLineViewController : BaseViewController <UISearchControllerDelegate,
                                                        UISearchResultsUpdating,
                                                        UISearchBarDelegate,
                                                        UITableViewDelegate,
                                                        UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)categoryButtonAction:(UIButton *)sender;
@end
