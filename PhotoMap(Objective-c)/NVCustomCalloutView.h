
#import <UIKit/UIKit.h>
#import "MapUiViewController.h"
#import "NVPhotoModel.h"

@interface NVCustomCalloutView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

-(instancetype)initWithFrame:(CGRect)frame withModel:(NVPhotoModel *)model andWithController:(MapUiViewController *)controller;
@end
