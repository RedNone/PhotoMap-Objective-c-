

#import "MapPhotoPopUp.h"
#import "FullPhotoViewController.h"
#import "NVSingletonFireBaseManager.h"
#import "NVConst.h"
#import "UIKit/UIKit.h"
#import "UIView+NVShadowExtension.h"
#import "UIImage+NVConvertImageExtension.h"

@interface MapPhotoPopUp()
@property(strong,nonatomic) NVPhotoModel *model;
@property(strong,nonatomic) MapUiViewController *controller;
@property(nonatomic,assign) bool isExistingPhoto;
@end

@implementation MapPhotoPopUp


- (instancetype)initWithFrame:(CGRect)frame withModel:(NVPhotoModel *)model andWithController:(MapUiViewController* )controller{
    self = [super initWithFrame:frame];
    if(self){
        self.controller = controller;
        self.model = model;
        [self initViewItems];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   withModel:(NVPhotoModel *)model
              withController:(MapUiViewController *)controller
           andWithExistingImage:(bool)isExistingPhoto{
    self = [super initWithFrame:frame];
    if(self){
        self.controller = controller;
        self.model = model;
        self.isExistingPhoto = isExistingPhoto;
        [self initViewItems];
    }
    return self;
}

- (void)initViewItems {
    [[NSBundle mainBundle] loadNibNamed:@"MapPhotoPopup" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    
    [self.contentView makeShadowWithSize:CGSizeMake(3.0f, 3.0f) andWithShadowOpacity:0.2f];
    self.contentView.layer.cornerRadius = 5;
    
    [self.imageView makeShadowWithSize:CGSizeMake(3.0f, 3.0f) andWithShadowOpacity:0.2f];
    
    if(self.isExistingPhoto){
        [self.imageView setImage:[[UIImage imageWithContentsOfFile:self.model.photoPath] scaledToSize:CGSizeMake(300, 400)]];
    } else{
        [self.imageView setImage:[self.model.photo scaledToSize:CGSizeMake(300, 400)]];
    }
    self.timeLabel.text = self.model.date;
    self.typeOfPhotoLabel.text = self.model.type;    
    self.descriptionTextField.text = self.model.text;
    
    UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(typeOfPhotoLabelAction:)];
    [self.typeOfPhotoLabel setUserInteractionEnabled:YES];
    [self.typeOfPhotoLabel addGestureRecognizer:gester];
    
    UITapGestureRecognizer *imageGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:imageGester];
}

- (void)makeShadowForView:(UIView *)someView {
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:someView.bounds];
    someView.layer.masksToBounds = NO;
    someView.layer.shadowColor = [UIColor blackColor].CGColor;
    someView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    someView.layer.shadowOpacity = 0.2f;
    someView.layer.shadowPath = shadowPath.CGPath;

}

#pragma mark - Actions

- (void)imageViewAction:(UIGestureRecognizer *)gester{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FullPhotoViewController *myController = [storyBoard instantiateViewControllerWithIdentifier:@"FullPhotoScreen"];
    self.model.text = self.descriptionTextField.text;    
    myController.model = self.model;
    [self.controller.navigationController pushViewController:myController animated:YES];

}

-(void)typeOfPhotoLabelAction:(UIGestureRecognizer *)gester{
    if(gester.state == UIGestureRecognizerStateBegan){
        [self callAlertControllerForLabel];
    }
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self removeFromSuperview];
   }

- (IBAction)doneButtonAction:(UIButton *)sender {
    
    self.model.text = self.descriptionTextField.text;
    
    if(!self.isExistingPhoto){
        [[NVSingletonFireBaseManager sharedManager] uploadData:self.model];
     
    } else{
        [[NVSingletonFireBaseManager sharedManager] updateDataWithModel:self.model];
    }
    [self removeFromSuperview];
}

#pragma mark - AlertController as Context Menu

- (void)callAlertControllerForLabel{
    
    UIAlertController* alert=   [UIAlertController
                                 alertControllerWithTitle:@"Select type of image"
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction: [UIAlertAction
                         actionWithTitle:TypeOfPhotoFriends
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self.typeOfPhotoLabel setText:TypeOfPhotoFriends];
                             self.model.type = TypeOfPhotoFriends;
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }]];
    [alert addAction: [UIAlertAction
                         actionWithTitle:TypeOfPhotoDefault
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self.typeOfPhotoLabel setText:TypeOfPhotoDefault];
                             self.model.type = TypeOfPhotoDefault;
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }]];
    [alert addAction: [UIAlertAction
                         actionWithTitle:TypeOfPhotoNature
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self.typeOfPhotoLabel setText:TypeOfPhotoNature];
                             self.model.type = TypeOfPhotoNature;
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [self.controller presentViewController:alert animated:YES completion:nil];
    
}



@end
