//
//  FullPhotoViewController.h
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 14.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVPhotoModel.h"

@interface FullPhotoViewController : UIViewController

@property (strong, nonatomic) NVPhotoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelWithTime;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
