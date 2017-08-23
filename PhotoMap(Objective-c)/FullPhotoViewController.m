//
//  FullPhotoViewController.m
//  PhotoMap(Objective-c)
//
//  Created by mac-228 on 14.08.17.
//  Copyright © 2017 mac-228. All rights reserved.
//

#import "FullPhotoViewController.h"
#import "UIImage+NVConvertImageExtension.h"

@interface FullPhotoViewController ()

@end

@implementation FullPhotoViewController

#pragma mark - Controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scrollView setMaximumZoomScale:5.f];
    [self.scrollView setMinimumZoomScale:1.f];
    [self.scrollView setClipsToBounds:YES];
    
    if(!self.model.photo){
        [self.imageView setImage:[UIImage imageWithContentsOfFile:self.model.photoPath] ];
    } else{
        [self.imageView setImage:self.model.photo];
    }
    
    [self.descriptionLabel setText:self.model.text];
    [self.labelWithTime setText:self.model.date];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    
    
    [self.footerView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [self.descriptionLabel setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
    [self.labelWithTime setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
    
    UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToImageView:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:gester];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapToImageView:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTapGesture];
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


#pragma mark - Actions
- (void)tapToImageView:(UIGestureRecognizer *)gester{
  
    if(self.navigationController.navigationBar.isHidden){
        [self.navigationController.navigationBar setHidden:NO];
        [UIView animateWithDuration:0.3f animations:^{
            self.navigationController.navigationBar.alpha = 1;
        }];
        [self.footerView setHidden:NO];
        [UIView animateWithDuration:0.3f animations:^{
            self.footerView.alpha = 1;
        }];
    } else{
        [UIView animateWithDuration:0.3f animations:^{
            self.navigationController.navigationBar.alpha = 0;
        } completion:^(BOOL finished) {
            [self.navigationController.navigationBar setHidden:YES];
        }];
        [UIView animateWithDuration:0.3f animations:^{
            self.footerView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.footerView setHidden:YES];
        }];
    }
}

-(void)doubleTapToImageView:(UIGestureRecognizer *)gester{
    if(self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    else
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
}

#pragma mark - ScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}



@end
