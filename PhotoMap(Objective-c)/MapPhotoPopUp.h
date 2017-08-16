//
//  MapPhotoPopUp.h
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 11.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPhotoPopUp.h"
#import "NVPhotoModel.h"
#import "MapUiViewController.h"

@interface MapPhotoPopUp : UIView
@property (strong,nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfPhotoLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;

-(instancetype)initWithFrame:(CGRect)frame withModel:(NVPhotoModel*) model andWithController:(MapUiViewController*) controller;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)doneButtonAction:(UIButton *)sender;

@end
