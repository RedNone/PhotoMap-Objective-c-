

#import <UIKit/UIKit.h>
#import "MapPhotoPopUp.h"
#import "NVPhotoModel.h"
#import "MapUiViewController.h"

@interface MapPhotoPopUp : UIView
@property (retain,nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *typeOfPhotoLabel;
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextField;

- (instancetype)initWithFrame:(CGRect)frame withModel:(NVPhotoModel *) model andWithController:(MapUiViewController *) controller;
- (instancetype)initWithFrame:(CGRect)frame
                   withModel:(NVPhotoModel *)model
              withController:(MapUiViewController *)controller
           andWithExistingImage:(bool)isExistingPhoto;

- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)doneButtonAction:(UIButton *)sender;

@end
