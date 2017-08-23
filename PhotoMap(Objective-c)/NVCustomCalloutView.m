
#import "NVCustomCalloutView.h"
#import "UIView+NVShadowExtension.h"
#import "UIImage+NVConvertImageExtension.h"
#import "MapPhotoPopUp.h"
#import "NVSingletonFireBaseManager.h"

@interface NVCustomCalloutView ()
@property(nonatomic,strong) NVPhotoModel *dataModel;
@property(nonatomic,strong) MapUiViewController *controller;
@end

@implementation NVCustomCalloutView

- (instancetype)initWithFrame:(CGRect)frame withModel:(NVPhotoModel *)model andWithController:(MapUiViewController *)controller{
    self = [super initWithFrame:frame];
    if(self){
        self.controller = controller;
        self.dataModel = model;
        [self initViewItems];
    }
    return self;
}

- (void)initViewItems {
    [[NSBundle mainBundle] loadNibNamed:@"CustomCalloutView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    self.contentView.layer.cornerRadius = 10;
    [self.photoImageView makeShadowWithSize:CGSizeMake(3.0f, 3.0f) andWithShadowOpacity:0.3f];
        
    self.photoImageView.image = [self.dataModel.photo scaledToSize:CGSizeMake(50, 50)];
    
    self.titleLabel.text = self.dataModel.text;
    self.dateLabel.text = self.dataModel.date;
    
    self.indicatorImageView.image = [[UIImage imageNamed:@"indicator"] scaledToSize:CGSizeMake(5, 5)];
    
    UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
    [self.contentView addGestureRecognizer:gester];
  
}

- (void)contentViewTapAction:(UIGestureRecognizer *)gester{
  
    MapPhotoPopUp *obj = [[MapPhotoPopUp alloc] initWithFrame: CGRectMake(self.controller.view.frame.size.width/2 - 150,self.controller.view.frame.size.height/2 - 207, 300, 414)
                                                    withModel: [[[NVSingletonFireBaseManager sharedManager] userData] objectAtIndex:self.dataModel.photoId]
                                            withController: self.controller
                                            andWithExistingImage:YES];
    
    [self.controller.view addSubview:obj];
    [self.controller.view bringSubviewToFront:obj];
}

@end
