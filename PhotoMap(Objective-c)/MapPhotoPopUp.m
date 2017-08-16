//
//  MapPhotoPopUp.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 11.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "MapPhotoPopUp.h"
#import "FullPhotoViewController.h"
#import "NVSingletonFireBaseManager.h"
#import "NVConst.h"
#import "UIKit/UIKit.h"

@interface MapPhotoPopUp()
@property(strong,nonatomic) NVPhotoModel *model;
@property(strong,nonatomic) MapUiViewController *controller;
@end
@implementation MapPhotoPopUp


-(instancetype)initWithFrame:(CGRect)frame withModel:(NVPhotoModel*) model andWithController:(MapUiViewController*) controller{
    self = [super initWithFrame:frame];
    if(self){
        self.controller = controller;
        self.model = model;
        [self initViewItems];
    }
    return self;
}

-(void) initViewItems {
    [[NSBundle mainBundle] loadNibNamed:@"MapPhotoPopup" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    
    [self makeShadowForView:self.contentView];
    self.contentView.layer.cornerRadius = 5;
    
    [self makeShadowForView:self.imageView];
    
    [self.imageView setImage:self.model.photo];
    [self.timeLabel setText:self.model.date];
    [self.typeOfPhotoLabel setText:self.model.type];
    
    UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(typeOfPhotoLabelAction:)];
    [self.typeOfPhotoLabel setUserInteractionEnabled:YES];
    [self.typeOfPhotoLabel addGestureRecognizer:gester];
    
    UITapGestureRecognizer *imageGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:imageGester];
}

-(void) makeShadowForView:(UIView *)someView {
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:someView.bounds];
    someView.layer.masksToBounds = NO;
    someView.layer.shadowColor = [UIColor blackColor].CGColor;
    someView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    someView.layer.shadowOpacity = 0.2f;
    someView.layer.shadowPath = shadowPath.CGPath;

}

#pragma mark - Actions

-(void) imageViewAction: (UIGestureRecognizer*) gester{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FullPhotoViewController *myController = [storyBoard instantiateViewControllerWithIdentifier:@"FullPhotoScreen"];
    self.model.text = self.descriptionTextField.text;    
    myController.model = self.model;
    [self.controller.navigationController pushViewController:myController animated:YES];

}

-(void) typeOfPhotoLabelAction:(UIGestureRecognizer*) gester{
    if(gester.state == UIGestureRecognizerStateBegan){
        [self callAlertControllerForLabel];
    }
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self removeFromSuperview];
   }

- (IBAction)doneButtonAction:(UIButton *)sender {
    self.model.text = self.descriptionTextField.text;
    [[NVSingletonFireBaseManager sharedManager] uploadData:self.model];
    [self removeFromSuperview];
}

#pragma mark - AlertController as Context Menu

-(void) callAlertControllerForLabel{
    
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
